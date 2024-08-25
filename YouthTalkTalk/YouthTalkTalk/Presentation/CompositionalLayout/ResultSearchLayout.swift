//
//  ResultSearchLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import UIKit

enum ResultSearchLayout: Int, CaseIterable {
    
    case condition
    case result
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = ResultSearchLayout(rawValue: section) ?? .result
            
            switch section {
            case .condition:
                return conditionLayout()
            case .result:
                return resultLayout()
            }
        }
        
        layout.register(TopRadiusDecoView.self,
                        forDecorationViewOfKind: TopRadiusDecoView.identifier)
        
        return layout
    }
    
    static func conditionLayout() -> NSCollectionLayoutSection {
        
        let section = NSCollectionLayoutSection(group: createEmptyGroup())
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [createHeader(TitleHeaderView.identifier)]
        
        return section
    }
    
    static func resultLayout() -> NSCollectionLayoutSection {
        
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
        section.boundarySupplementaryItems = [createHeader(TitleHeaderView.identifier)]
        
        // 데코뷰 추가
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: TopRadiusDecoView.identifier)
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
