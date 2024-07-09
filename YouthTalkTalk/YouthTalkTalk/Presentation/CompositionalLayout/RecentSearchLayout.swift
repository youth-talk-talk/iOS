//
//  RecentSearchLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/9/24.
//

import UIKit

enum RecentSearchLayout: Int, CaseIterable {
    
    case recent
    case search
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = RecentSearchLayout(rawValue: section) ?? .recent
            
            switch section {
            case .recent:
                return recentLayout()
            case .search:
                return searchLayout()
            }
        }
        
        layout.register(PopularDecoReusableView.self, forDecorationViewOfKind: PopularDecoReusableView.identifier)
        layout.register(RecentDecoReusableView.self, forDecorationViewOfKind: RecentDecoReusableView.identifier)
        
        return layout
    }
    
    static func recentLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets, bottom: 0, trailing: insets)
        
        // 헤더 추가
        // section.boundarySupplementaryItems = [createHeader(PopularHeaderReusableView.identifier)]
        
        return section
    }
    
    static func searchLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets, bottom: 0, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader(RecentHeaderReusableView.identifier)]
        
        return section
    }
    
    // 헤더 생성
    private static func createHeader(_ elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: elementKind, alignment: .top)
        
        return header
    }
}

