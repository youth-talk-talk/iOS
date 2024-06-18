//
//  HomeLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

enum HomeLayout: Int, CaseIterable {
    
    case popular
    case recent
    
    static func layout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { section, environment in
            
            let section = HomeLayout(rawValue: section) ?? .popular
            
            switch section {
            case .popular:
                return popularLayout()
            case .recent:
                return recentLayout()
            }
        }
    }
    
    static func popularLayout() -> NSCollectionLayoutSection {
        
        let insets = UIScreen.main.bounds.width * 0.1
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(141),
                                              heightDimension: .absolute(152))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(300),
                                               heightDimension: .absolute(152))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: insets, bottom: 0, trailing: insets)
        section.boundarySupplementaryItems = [createHeader(PopularHeaderReusableView.identifier)]
        
        // section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
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
        // section.boundarySupplementaryItems = [createHeader(TripCardCollectionReusableView.identifier)]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private static func createHeader(_ elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: elementKind, alignment: .top)
        
        return header
    }
}
