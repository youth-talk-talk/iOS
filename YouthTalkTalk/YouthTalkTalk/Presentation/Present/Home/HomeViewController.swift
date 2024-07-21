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
    var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, HomeSectionItems>()
    
    init(viewModel: HomeInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCollectionView() {
        
        layoutView.collectionView.prefetchDataSource = self
        
        cellRegistration()
        headerRegistration()
    }
    
    override func bind() {
        
        snapshot.appendSections([.category, .popular, .recent])
        
        viewModel.output.topFivePoliciesRelay
            .bind(with: self) { owner, topFivePolicies in
                
                owner.update(section: .popular, items: topFivePolicies)
                
            }.disposed(by: disposeBag)
        
        viewModel.output.allPoliciesRelay
            .bind(with: self) { owner, allPolicies in
                
                owner.update(section: .recent, items: allPolicies)
                
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
            
            cell.configure(data: itemIdentifier.data)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) {  [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self else { return nil }
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
            
            let tapGesture = UITapGestureRecognizer()
            supplementaryView.transparentView.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let viewModel = SearchViewModel()
                    
                    let nextVC = SearchViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }.disposed(by: disposeBag)
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
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: categoryHeaderRegistration,
                    for: index)
                
            case PopularHeaderReusableView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration,
                    for: index)
                
            case RecentHeaderReusableView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
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
        
        // #if DEBUG
        let commandButton = UIButton()
        commandButton.designed(title: "DEBUG", bgColor: .clear, fontType: .g14Bold)
        let commandItem = UIBarButtonItem(customView: commandButton)
        self.navigationItem.rightBarButtonItem = commandItem
        
        commandButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                owner.modalPresentationStyle = .formSheet
                owner.present(DebugViewController(), animated: true)
                
            }.disposed(by: disposeBag)
        
        // #endif
    }
    
    func update(section: HomeLayout, items: [HomeSectionItems]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        print("HomeViewController Deinit")
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        // 아이템 총 갯수 - 셀 위치 < 5보다 작으면
        // 아이템 총 갯수 / 10 + 1로 다음 페이지로 늘림
        // 페이지가 올라가면 fetch
        
        let total = viewModel.allPoliciesCount()
    
        indexPaths.forEach { indexPath in
            
            let currentPosition = indexPath.item
            let nextPage: Int = (total / 10) + 1
            
            if total - currentPosition < 7 {
                viewModel.input.updateRecentPolicies.accept(nextPage)
            }
        }
    }
}
