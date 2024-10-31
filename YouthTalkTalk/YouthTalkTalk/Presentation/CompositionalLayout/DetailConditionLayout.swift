//
//  DetailConditionLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/14/24.
//

import UIKit

enum DetailConditionLayout: Int, CaseIterable {
    
    case age
    case employmentStatus
    case deadlineStatus
    
    var count: Int {
        switch self {
        case .age:
            return 1
        case .employmentStatus:
            return 11
        case .deadlineStatus:
            return 3
        }
    }
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = DetailConditionLayout(rawValue: section) ?? .age
            
            switch section {
            case .age:
                return ageLayout()
            case .employmentStatus:
                return employmentLayout()
            case .deadlineStatus:
                return deadlineLayout()
            }
        }
        
        return layout
    }
    
    static func ageLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: insets, bottom: 24, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader("age")]
        
        return section
    }
    
    static func employmentLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2),
                                              heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(11)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: insets, bottom: 24, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader("employment")]
        
        return section
    }
    
    static func deadlineLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2),
                                              heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(11)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: insets, bottom: 24, trailing: insets)
        
        // 헤더 추가
        section.boundarySupplementaryItems = [createHeader("deadline")]
        
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
