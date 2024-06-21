//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import PinLayout

final class HomeViewController: BaseViewController<HomeView> {
    
    var dataSource: UICollectionViewDiffableDataSource<HomeLayout, AnyHashable>!
    
    override func configureCollectionView() {
        
        cellRegistration()
        headerRegistration()
        update()
    }
    
    private func cellRegistration() {
        
        let popularSectionRegistration = UICollectionView.CellRegistration<PopularCollectionViewCell, AnyHashable> { [weak self] cell, indexPath, itemIdentifier in
            
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
            
            return nil
        }
    }
    
    private func headerRegistration() {
        
        // Category Header Registration
        let categoryHeaderRegistration = UICollectionView.SupplementaryRegistration<CategoryCollectionReusableView>(elementKind: CategoryCollectionReusableView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            // guard let self else { return }
        }
        
        
        // Popular Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<PopularHeaderReusableView>(elementKind: PopularHeaderReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
            guard let section = HomeLayout(rawValue: indexPath.section) else { return }
            
            switch section {
            case .popular:
                break
            default: break
            }
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case CategoryCollectionReusableView.identifier:
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: categoryHeaderRegistration, for: index)
                
            case PopularHeaderReusableView.identifier:
                
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration, for: index)
                
            default: return nil
            }
        }
    }
    
    override func configureNavigation() {
        
        let customLabel = UILabel()
        customLabel.designed(text: "청년톡톡", fontType: .titleForAppBold, textColor: .black)
        
        let customView = UIBarButtonItem(customView: customLabel)
        
        self.navigationItem.leftBarButtonItem = customView
    }
    
    func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, AnyHashable>()
        
        snapshot.appendSections([.category, .popular])
        
        snapshot.appendItems(["1", "2", "3", "4", "5", "6"], toSection: .popular)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
