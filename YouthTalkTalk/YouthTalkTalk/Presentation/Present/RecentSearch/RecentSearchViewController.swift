//
//  RecentSearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit

final class RecentSearchViewController: BaseViewController<RecentSearchView> {
    
    var dataSource: UICollectionViewDiffableDataSource<RecentSearchLayout, AnyHashable>!
    
    override func configureCollectionView() {
        
        cellRegistration()
        headerRegistration()
        update()
    }
    
    private func cellRegistration() {
        
        // 최근검색 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentSearchCollectionViewCell, AnyHashable> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = RecentSearchLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .recent {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.flexView.backgroundColor = .lime40
                
                return cell
            }
            
            return nil
        }
    }
    
    private func headerRegistration() {
        
        // 최근업데이트 Header Registration
        let recentSearchHeaderRegistration = UICollectionView.SupplementaryRegistration<RecentSearchCollectionReusableView>(elementKind: RecentSearchCollectionReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
            // guard let self else { return }
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case RecentSearchCollectionReusableView.identifier:
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: recentSearchHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }
    
    func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<RecentSearchLayout, AnyHashable>()
        
        snapshot.appendSections([.recent])
        
        snapshot.appendItems(["1", "2", "3", "4", "5", "6"], toSection: .recent)
        // snapshot.appendItems(["a", "b", "c", "d", "e", "f"], toSection: .search)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
