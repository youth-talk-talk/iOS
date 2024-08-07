//
//  CommunityForumViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit

enum CommunitySectionItems: Hashable {
    
    case search
    case popular(PolicyEntity)
    case recent(PolicyEntity)
    
    var data: PolicyEntity? {
        switch self {
        case .search:
            return nil
        case .popular(let policyEntity):
            return policyEntity
        case .recent(let policyEntity):
            return policyEntity
        }
    }
}

class CommunityForumViewController: BaseViewController<CommunityForumView> {
    
    var dataSource: UICollectionViewDiffableDataSource<CommunityLayout, CommunitySectionItems>!
    var snapshot = NSDiffableDataSourceSnapshot<CommunityLayout, CommunitySectionItems>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellRegistration()
        headerRegistration()
        
        let entity = [PolicyEntity.mockupData()]
        let entities = entity.map { CommunitySectionItems.popular($0) }
        
        let newentity = [PolicyEntity.mockupData()]
        let newentities = newentity.map { CommunitySectionItems.popular($0) }
        
        update(section: .popular, items: entities)
        update(section: .recent, items: newentities)
    }
    
    override func bind() {
        
        snapshot.appendSections([.search, .popular, .recent])
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        // 인기정책 Section
        let popularSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, CommunitySectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            print("popularSectionRegistration")
            cell.configure(data: itemIdentifier.data)
        }
        
        // 최근 업데이트 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, CommunitySectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            print("recentSectionRegistration")
            
            cell.configure(data: itemIdentifier.data)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = CommunityLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .search { return nil }
            
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
        let searchHeaderRegistration = UICollectionView.SupplementaryRegistration<SearchCollectionReusableView>(elementKind: SearchCollectionReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        // 인기정책 Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<PopularHeaderReusableView>(elementKind: PopularHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        // 최근업데이트 Header Registration
        let recentHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentHeaderReusableView>(elementKind: RecentHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case SearchCollectionReusableView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: searchHeaderRegistration,
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

    func update(section: CommunityLayout, items: [CommunitySectionItems]) {
            
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}