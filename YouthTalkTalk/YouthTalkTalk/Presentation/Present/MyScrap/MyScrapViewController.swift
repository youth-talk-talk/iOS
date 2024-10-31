//
//  MyScrapViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class MyScrapViewController: RootViewController {
    
    private let viewModel: MyScrapInterface

    private var dataSource: UICollectionViewDiffableDataSource<MyScrapSection, PolicyEntity>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyScrapSection, PolicyEntity>()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MyScrapSection.layout())
    
    init(viewModel: MyScrapInterface) {
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
        
        updateNavigationTitle(title: "스크랩한 정책")
        updateNavigationBackButtonTitle()
        
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .gray10
        
        snapshot.appendSections([.scrap])
        
        let recentCellRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, PolicyEntity> { cell, indexPath, itemIdentifier in
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.configure(data: itemIdentifier)
            
            let data = itemIdentifier.policyId
            
            cell.scrapButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    owner.viewModel.input.updateScrap.accept(data)
                }
                .disposed(by: cell.disposeBag)
            
            cell.tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let repository = PolicyRepositoryImpl()
                    let useCase = PolicyUseCaseImpl(policyRepository: repository)
                    let viewModel = PolicyViewModel(policyID: itemIdentifier.policyId, policyUseCase: useCase)
                    let nextVC = PolicyViewController(viewModel: viewModel)
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        
        dataSource = UICollectionViewDiffableDataSource<MyScrapSection, PolicyEntity>(collectionView: collectionView) {
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
            .bind(with: self) { owner, policyEntities in
                owner.update(section: .scrap, items: policyEntities)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.canceledScrapEntity
            .bind(with: self) { owner, scrapEntity in
                
                let policyItems = owner.snapshot.itemIdentifiers(inSection: .scrap)
                
                guard let item = policyItems.filter({ $0.policyId == scrapEntity.id }).first else { return }
                
                owner.delete(item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.input.fetchScrapEvent.accept(())
    }
}

extension MyScrapViewController {
    
    func update(section: MyScrapSection, items: [PolicyEntity]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: PolicyEntity) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
}
