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

class MyScrapRPViewController: RootViewController {
    
    private let viewModel: MyRPScrapInterface
    
    private var dataSource: UICollectionViewDiffableDataSource<MyScrapSection, RPEntity>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyScrapSection, RPEntity>()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MyScrapSection.layout())
    
    init(viewModel: MyRPScrapInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func configureView() {
        
        updateNavigationTitle(title: "스크랩한 게시물")
        updateNavigationBackButtonTitle()
        
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .gray10
        
        snapshot.appendSections([.scrap])
        
        let recentCellRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, RPEntity> { cell, indexPath, itemIdentifier in
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.configure(data: itemIdentifier)
            
            // cell.scrapButton.rx.tap
            //     .bind(with: self) { owner, _ in
            //
            //         owner.viewModel.input.updatePolicyScrap.accept(data)
            //     }
            //     .disposed(by: cell.disposeBag)
            
            cell.tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let repository = ReviewRepositoryImpl()
                    let commentRepository = CommentRepositoryImpl()
                    let useCase = ReviewUseCaseImpl(reviewRepository: repository)
                    let commentUseCase = CommentUseCaseImpl(commentRepository: commentRepository)
                    let viewModel = ReviewDetailViewModel(data: itemIdentifier, useCase: useCase, commnetUseCase: commentUseCase)
                    let resultDetailVC = ResultDetailViewController(viewModel: viewModel)
                    
                    owner.navigationController?.pushViewController(resultDetailVC, animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        
        dataSource = UICollectionViewDiffableDataSource<MyScrapSection, RPEntity>(collectionView: collectionView) {
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
        
        viewModel.output.scrap
            .bind(with: self) { owner, rpEntities in
                // owner.update(section: .scrap, items: rpEntities)
            }
            .disposed(by: disposeBag)
        
        // viewModel.output.canceledScrapEntity
        //     .bind(with: self) { owner, scrapEntity in
        //         
        //         let policyItems = owner.snapshot.itemIdentifiers(inSection: .scrap)
        //         
        //         guard let item = policyItems.filter({ $0.policyId == scrapEntity.id }).first else { return }
        //         
        //         owner.delete(item: item)
        //     }
        //     .disposed(by: disposeBag)
        
        viewModel.input.fetchScrapEvent.accept(())
    }
}

extension MyScrapRPViewController {
    
    func update(section: MyScrapSection, items: [RPEntity]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: RPEntity) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
}
