//
//  LikedCommentListViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 12/11/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import Combine

final class LikedOrMyCommentListViewController: RootViewController {
    
    private let viewModel: MyRPScrapInterface
    private var cancelBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<MyScrapSection, LikedCommentData>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyScrapSection, LikedCommentData>()
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: MyScrapSection.commentListLayout()).then {
        $0.backgroundColor = .clear
    }
    
    private let listType: ListType
    
    private let commentTextFieldView = CommentTextFieldView()
    private var idOfChangingComment: Int = 0
    
    init(viewModel: MyRPScrapInterface, listType: ListType) {
        self.viewModel = viewModel
        self.listType = listType
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        commentTextFieldView.commentTap.rx.event
            .bind(with: self) { [weak self] owner, _ in
                guard let self, let text = commentTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else { return }
                
                owner.viewModel.input.editComment(commentId: idOfChangingComment,
                                                  newComment: text)
            }
            .disposed(by: disposeBag)
        
        // MARK: 댓글 삭제 API 완료
        viewModel.output.successDeleteComment.sink { [weak self] deletedCommentId in
            guard let self,
                  let deletedComment: LikedCommentData = dataSource.snapshot().itemIdentifiers.first(where: { $0.commentId == deletedCommentId }) else { return }
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([deletedComment])
            
            dataSource.apply(snapshot, animatingDifferences: true)
        }.store(in: &cancelBag)
        
        // MARK: 댓글 수정 API 완료
        viewModel.output.successEditComment.sink { [weak self] (commentId, commentContent) in
            guard let self,
                  var editedCommentView: LikedCommentData = dataSource.snapshot().itemIdentifiers.first(where: { $0.commentId == commentId }) else { return }
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([editedCommentView])
            editedCommentView.content = commentContent
            snapshot.appendItems([editedCommentView])
            
            commentTextFieldView.textField.resignFirstResponder()
            commentTextFieldView.textField.text = ""
            
            commentTextFieldView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(64)
            }
            
            dataSource.apply(snapshot, animatingDifferences: true)
        }.store(in: &cancelBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func configureView() {
        
        updateNavigationTitle(title: listType == .likedComment ? "좋아요한 댓글" : "작성한 댓글")
        
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .gray10
        
        snapshot.appendSections([.scrap])
        
        let recentCellRegistration = UICollectionView.CellRegistration<CommentCell, LikedCommentData> { [weak self] cell, indexPath, data in
            guard let self else { return }
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.bind(userName: data.nickname,
                      commentId: data.commentId,
                      comment: data.content,
                      isItOwnComment: (listType == .myWrittenComment),
                      isLiked: (listType == .likedComment))
            
            // MARK: 댓글 삭제 버튼
            cell.commentView.deleteLabel.onTapped { [weak self] in
                self?.viewModel.input.commentDelete(data.commentId)
            }
            
            // MARK: 댓글 수정 버튼
            cell.commentView.editLabel.onTapped { [weak self] in
                guard let self else { return }
                
                commentTextFieldView.textField.becomeFirstResponder()
                commentTextFieldView.textField.text = data.content
                idOfChangingComment = data.commentId
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<MyScrapSection, LikedCommentData>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            commentTextFieldView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-keyboardRectangle.height)
            }
        }
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        view.addSubview(commentTextFieldView)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(commentTextFieldView.snp.top)
        }
        
        commentTextFieldView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(64)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
    
    override func bind() {
        if listType == .likedComment {
            viewModel.output.likedCommentList.subscribe { [weak self] commentList in
                self?.update(section: .scrap, items: commentList)
            }.disposed(by: disposeBag)
            
            viewModel.input.fetchLikedComment.accept(())
            
        } else if listType == .myWrittenComment {
            viewModel.output.myCommentList.subscribe { [weak self] commentList in
                self?.update(section: .scrap, items: commentList)
            }.disposed(by: disposeBag)
            
            viewModel.input.fetchMyComment.accept(())
        }
    }
}

extension LikedOrMyCommentListViewController {
    
    func update(section: MyScrapSection, items: [LikedCommentData]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: LikedCommentData) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
}
