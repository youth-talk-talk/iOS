//
//  HomeLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

enum HomeLayout: Int, CaseIterable {
    
    case category
    case popular
    case recent
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = HomeLayout(rawValue: section) ?? .popular
            
            switch section {
            case .category:
                return categoryLayout()
            case .popular:
                return popularLayout()
            case .recent:
                return recentLayout()
            }
        }
        
        layout.register(PopularDecoReusableView.self, forDecorationViewOfKind: PopularDecoReusableView.identifier)
        
        return layout
    }
    
    static func categoryLayout() -> NSCollectionLayoutSection {
        
        let section = NSCollectionLayoutSection(group: createEmptyGroup())
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [createHeader(CategoryCollectionReusableView.identifier)]
        
        return section
    }
    
    static func popularLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(141),
                                              heightDimension: .absolute(152))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(300),
                                               heightDimension: .absolute(152))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets, bottom: 0, trailing: insets)
        section.boundarySupplementaryItems = [createHeader(PopularHeaderReusableView.identifier)]
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: PopularDecoReusableView.identifier)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    static func recentLayout() -> NSCollectionLayoutSection {
        
        let ratio: CGFloat = 0.7
        let groupInterSpacing = UIScreen.main.bounds.width * (1.0 - ratio) / 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ratio),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupInterSpacing
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
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
