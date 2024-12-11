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

class LikedCommentListViewController: RootViewController {
    
    private let viewModel: MyRPScrapInterface
    
    private var dataSource: UICollectionViewDiffableDataSource<MyScrapSection, LikedCommentData>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyScrapSection, LikedCommentData>()
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: MyScrapSection.commentListLayout()).then {
        $0.backgroundColor = .clear
    }
    
    private let listType: ListType
    
    init(viewModel: MyRPScrapInterface, listType: ListType) {
        self.viewModel = viewModel
        self.listType = listType
        
        super.init(nibName: nil, bundle: nil)
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
        updateNavigationBackButtonTitle()
        
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .gray10
        
        snapshot.appendSections([.scrap])
        
        let recentCellRegistration = UICollectionView.CellRegistration<CommentCell, LikedCommentData> { [weak self] cell, indexPath, data in
            guard let self else { return }
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.backgroundColor = .red
            cell.bind(userName: data.nickname,
                      commentId: data.commentId,
                      comment: data.content,
                      isItOwnComment: (listType == .myWrittenComment),
                      isLiked: (listType == .likedComment))
        }
        
        dataSource = UICollectionViewDiffableDataSource<MyScrapSection, LikedCommentData>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
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

extension LikedCommentListViewController {
    
    func update(section: MyScrapSection, items: [LikedCommentData]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: LikedCommentData) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
}
