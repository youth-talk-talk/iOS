//
//  MyScrapRPViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class MyPolicyOrPostListViewController: RootViewController {
    
    private let viewModel: MyRPScrapInterface
    private let listType: ListType
    
    private lazy var page: Int = 0
    
    private var dataSource: UICollectionViewDiffableDataSource<MyScrapSection, RPEntity>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyScrapSection, RPEntity>()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MyScrapSection.layout()).then {
        $0.backgroundColor = .clear
    }
    
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
        
        // TODO: 게시글 삭제 후 리스트 최신화
//        if listType == .myPost {
//            viewModel.input.fetchMyPost.accept(0)
//        }
    }
//    
//    override func configureView() {
//        
//        updateNavigationTitle(title: listType == .scrapPost ? "스크랩한 게시물" : "작성한 게시물")
//        
//        self.view.backgroundColor = .white
//        collectionView.backgroundColor = .gray10
//        
//        snapshot.appendSections([.scrap])
//        
//        let recentCellRegistration = UICollectionView.CellRegistration<PostListCollectionViewCell, RPEntity> { cell, indexPath, itemIdentifier in
//            
//            cell.layer.cornerRadius = 10
//            cell.layer.masksToBounds = true
//            cell.configure(data: itemIdentifier)
//            
//            cell.scrapButton.onTapped { [weak self] in
//                let id = String(itemIdentifier.postId ?? 0)
//                self?.viewModel.input.updateScrap.accept(id)
//            }
//            
//            cell.tapGesture.rx.event
//                .bind(with: self) { owner, _ in
//                    
//                    let repository = ReviewRepositoryImpl()
//                    let commentRepository = CommentRepositoryImpl()
//                    let useCase = ReviewUseCaseImpl(reviewRepository: repository)
//                    let commentUseCase = CommentUseCaseImpl(commentRepository: commentRepository)
//                    let viewModel = PosetDetailViewModel(data: itemIdentifier, useCase: useCase, commnetUseCase: commentUseCase)
//                    let resultDetailVC = PostDetailViewController(viewModel: viewModel)
//                    resultDetailVC.delegate = self
//                    owner.navigationController?.pushViewController(resultDetailVC, animated: true)
//                }
//                .disposed(by: cell.disposeBag)
//            
//            // cell에 적용(스크롤시에도 유지)
//            if let postId = itemIdentifier.postId,
//               let scrap = self.viewModel.scrapStatus[String(postId)] {
//                
//                cell.updateScrapStatus(scrap, 0)
//            }
//            
//            // cell에 즉시 적용
//            self.viewModel.scrapStatusRelay
//                .bind(with: self) { owner, scrapStatus in
//                    if let postId = itemIdentifier.postId,
//                       let scrap = scrapStatus[String(postId)] {
//                        cell.updateScrapStatus(scrap, 0)
//                    }
//                }
//                .disposed(by: self.disposeBag)
//        }
//        
//        dataSource = UICollectionViewDiffableDataSource<MyScrapSection, RPEntity>(collectionView: collectionView) {
//            collectionView, indexPath, itemIdentifier in
//            
//            return collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: itemIdentifier)
//        }
//    }
//    
//    override func configureLayout() {
//        
//        flexView.flex.define { flex in
//            
//            flex.addItem(collectionView)
//                .width(100%)
//                .grow(1)
//        }
//    }
//    
//    override func bind() {
//        if listType == .scrapPost {
//            viewModel.output.scrap
//                .bind(with: self) { owner, rpEntities in
//                    owner.update(section: .scrap, items: rpEntities)
//                }
//                .disposed(by: disposeBag)
//            
//            viewModel.output.canceledScrapEntity
//                .bind(with: self) { owner, scrapEntity in
//                    
//                    let policyItems = owner.snapshot.itemIdentifiers(inSection: .scrap)
//                    
//                    guard let item = policyItems.filter({ ($0.policyId == scrapEntity.id) || ((String($0.postId ?? 0) == scrapEntity.id)) }).first else { return }
//                    
//                    owner.delete(item: item)
//                }
//                .disposed(by: disposeBag)
//            
//            viewModel.input.fetchScrapEvent.accept(())
//            
//        } else if listType == .myPost {
//            viewModel.output.myPost
//                .bind(with: self) { owner, rpEntities in
//                    owner.update(section: .scrap, items: rpEntities)
//                }
//                .disposed(by: disposeBag)
//            
//            viewModel.input.fetchMyPost.accept(page)
//        }
//    }
}

extension MyPolicyOrPostListViewController: RemoveReportedPostProtocol {
    
    func update(section: MyScrapSection, items: [RPEntity]) {
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: RPEntity) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
    
    func removeReportedPost(postId: Int) {
        guard let reportedPost: RPEntity = dataSource.snapshot().itemIdentifiers.first(where: { _ in postId == postId }) else { return }
        var newSnapshot = dataSource.snapshot()
        newSnapshot.deleteItems([reportedPost])
        
        self.dataSource.apply(newSnapshot, animatingDifferences: true)
    }
}
