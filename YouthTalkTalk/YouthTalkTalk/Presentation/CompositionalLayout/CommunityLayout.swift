//
//  CommunityLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit

enum CommunityLayout: Int, CaseIterable {
    
    case search
    case popular
    case recent
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = CommunityLayout(rawValue: section) ?? .popular
            
            switch section {
            case .search:
                return categoryLayout()
            case .popular:
                return popularLayout()
            case .recent:
                return recentLayout()
            }
        }
        
        layout.register(SearchCollectionReusableView.self,
                        forDecorationViewOfKind: SearchCollectionReusableView.identifier)
        layout.register(PopularDecoReusableView.self,
                        forDecorationViewOfKind: PopularDecoReusableView.identifier)
        layout.register(RecentDecoReusableView.self,
                        forDecorationViewOfKind: RecentDecoReusableView.identifier)
        
        return layout
    }
    
    static func categoryLayout() -> NSCollectionLayoutSection {
        
        let section = NSCollectionLayoutSection(group: createEmptyGroup())
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [createHeader(SearchCollectionReusableView.identifier)]
        
        return section
    }
    
    static func popularLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets, bottom: 0, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader(PopularHeaderReusableView.identifier)]
        
        // 데코뷰 추가
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: PopularDecoReusableView.identifier)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    static func recentLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets, bottom: 0, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader(PopularHeaderReusableView.identifier)]
        
        // 데코뷰 추가
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: RecentDecoReusableView.identifier)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    // 헤더 생성
    private static func createHeader(_ elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: elementKind, alignment: .top)
        
        return header
    }
    
    private static func createEmptyGroup() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)), subitems: [item])
        return group
    }
}
