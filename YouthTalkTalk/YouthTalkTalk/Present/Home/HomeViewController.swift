//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import PinLayout

class HomeViewController: BaseViewController<HomeView> {
    
    var dataSource: UICollectionViewDiffableDataSource<HomeLayout, AnyHashable>!
    
    override func configureCollectionView() {
        
        cellRegistration()
        headerRegistration()
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
            
            guard let self else { return }
            
            let safeAreaInset = self.layoutView.safeAreaInsets.top
            
            supplementaryView.layout(safeAreaInset: safeAreaInset)
        }
        
        
        // Popular Header Registration
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
    
    func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, AnyHashable>()
        
        snapshot.appendSections([.category, .popular])
        
        snapshot.appendItems(["1", "2", "3", "4"], toSection: .popular)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
