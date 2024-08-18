//
//  RecentSearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RecentSearchViewController: BaseViewController<RecentSearchView> {
    
    var dataSource: UICollectionViewDiffableDataSource<RecentSearchLayout, String>!
    var viewModel: RecentSearchInterface
    
    init(viewModel: RecentSearchInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCollectionView() {
        
        cellRegistration()
        headerRegistration()
    }
    
    override func bind() {
        
        viewModel.output.recentSearchListRelay
            .bind(with: self) { owner, recentSearchList in
                
                owner.update(recentSearchList)
            }
            .disposed(by: disposeBag)
        
        viewModel.input.fetchRecentSearchList.accept(())
    }
    
    private func cellRegistration() {
        
        // 최근검색 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentSearchCollectionViewCell, String> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: recentSectionRegistration, for: indexPath, item: itemIdentifier)
            
            cell.configure(title: itemIdentifier)
            
            cell.removeButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    owner.viewModel.input.removeRecentSearchList.accept(itemIdentifier)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func headerRegistration() {
        
        // 최근 검색 Header Registration
        let recentSearchHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { supplementaryView, elementKind, indexPath in
            
            supplementaryView.setTitle("최근 검색")
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case TitleHeaderView.identifier:
                return layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: recentSearchHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }
    
    func update(_ recentSearchList: [String]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<RecentSearchLayout, String>()
        
        snapshot.appendSections([.recent])
        
        snapshot.appendItems(recentSearchList, toSection: .recent)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
