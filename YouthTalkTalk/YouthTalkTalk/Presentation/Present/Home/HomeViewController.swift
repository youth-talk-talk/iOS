//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import PinLayout
import RxCocoa

enum HomeSectionItems: Hashable {
    
    case category
    case topFive(PolicyEntity)
    case all(PolicyEntity)
    
    var data: PolicyEntity? {
        switch self {
        case .category:
            return nil
        case .topFive(let policyEntity):
            return policyEntity
        case .all(let policyEntity):
            return policyEntity
        }
    }
}

final class HomeViewController: BaseViewController<HomeView> {
    
    let viewModel: HomeInterface
    
    var dataSource: UICollectionViewDiffableDataSource<HomeLayout, HomeSectionItems>!
    
    init(viewModel: HomeInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCollectionView() {
        
        cellRegistration()
        headerRegistration()
        update()
    }
    
    override func bind() {
        
        viewModel.output.fetchPoliciesSuccess
            .bind(with: self) { owner, _ in
                
                owner.update()
                
            }.disposed(by: disposeBag)
        
        viewModel.input.fetchPolicies.accept(())
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        // 인기정책 Section
        let popularSectionRegistration = UICollectionView.CellRegistration<PopularCollectionViewCell, HomeSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier.data)
        }
        
        // 최근 업데이트 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, HomeSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = HomeLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .category { return nil }
            
            if section == .popular {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: popularSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
            
            if section == .recent {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
            
            return nil
        }
    }
    
    //MARK: Header Registration
    private func headerRegistration() {
        
        // 카테고리 Header Registration
        let categoryHeaderRegistration = UICollectionView.SupplementaryRegistration<CategoryCollectionReusableView>(elementKind: CategoryCollectionReusableView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            supplementaryView.searchBar.rx.textDidBeginEditing
                .subscribe(with: self) { owner, _ in
                    
                    let viewModel = SearchViewModel()
                    
                    let nextVC = SearchViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }.disposed(by: self.disposeBag)
        }
        
        
        // 인기정책 Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<PopularHeaderReusableView>(elementKind: PopularHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
            // guard let section = HomeLayout(rawValue: indexPath.section) else { return }
        }
        
        // 최근업데이트 Header Registration
        let recentHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentHeaderReusableView>(elementKind: RecentHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
            // guard let self else { return }
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case CategoryCollectionReusableView.identifier:
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: categoryHeaderRegistration,
                    for: index)
                
            case PopularHeaderReusableView.identifier:
                
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration,
                    for: index)
                
            case RecentHeaderReusableView.identifier:
                
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: recentHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }
    
    override func configureNavigation() {
        
        let customLabel = UILabel()
        customLabel.designed(text: "청년톡톡", fontType: .g20Bold, textColor: .black)
        
        let customView = UIBarButtonItem(customView: customLabel)
        
        self.navigationItem.leftBarButtonItem = customView
        
        #if DEBUG
        let commandButton = UIButton()
        commandButton.designed(title: "DEBUG", bgColor: .clear, fontType: .g14Bold)
        let commandItem = UIBarButtonItem(customView: commandButton)
        self.navigationItem.rightBarButtonItem = commandItem
        
        commandButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                owner.modalPresentationStyle = .formSheet
                owner.present(DebugViewController(), animated: true)
                
            }.disposed(by: disposeBag)
        
        #endif
    }
    
    func update() {
        
        let topFivePolicies = viewModel.output.topFivePolicies
        let allPolicies = viewModel.output.allPolicies
        
        var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, HomeSectionItems>()
        
        snapshot.appendSections([.category, .popular, .recent])
        
        snapshot.appendItems(topFivePolicies, toSection: .popular)
        snapshot.appendItems(allPolicies, toSection: .recent)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
