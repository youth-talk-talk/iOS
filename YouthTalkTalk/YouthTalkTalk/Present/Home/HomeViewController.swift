//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

class HomeViewController: BaseViewController<HomeView> {
    
    var dataSource: UICollectionViewDiffableDataSource<HomeLayout, AnyHashable>!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let popularSectionRegistration = UICollectionView.CellRegistration<PopularCollectionViewCell, AnyHashable> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self, let section = HomeLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .popular {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: popularSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
            
            return nil
        }
        
        // Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<PopularHeaderReusableView>(elementKind: PopularHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
            guard let section = HomeLayout(rawValue: indexPath.section) else { return }
            
            switch section {
            case .popular:
                supplementaryView.backgroundColor = .brown
            default: break
            }
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case PopularHeaderReusableView.identifier:
                
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration, for: index)
                
            default: return nil
            }
            
        }
        
        // update
        var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, AnyHashable>()
        
        snapshot.appendSections([.popular])
        
        snapshot.appendItems(["1", "2", "3", "4"], toSection: .popular)
     
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
