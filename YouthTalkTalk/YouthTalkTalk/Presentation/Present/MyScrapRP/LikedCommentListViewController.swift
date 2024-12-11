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
    
    init(viewModel: MyRPScrapInterface) {
        self.viewModel = viewModel
        
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
        
        updateNavigationTitle(title: "좋아요한 댓글")
        updateNavigationBackButtonTitle()
        
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .gray10
        
        snapshot.appendSections([.scrap])
        
        let recentCellRegistration = UICollectionView.CellRegistration<CommentCell, LikedCommentData> { cell, indexPath, data in
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.backgroundColor = .red
            cell.bind(userName: data.nickname,
                      commentId: data.commentId,
                      comment: data.content,
                      isItOwnComment: false,
                      isLiked: true)
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
        viewModel.output.likedCommentList.subscribe { [weak self] commentList in
            self?.update(section: .scrap, items: commentList)
        }.disposed(by: disposeBag)
        
        viewModel.input.fetchLikedComment.accept(())
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
