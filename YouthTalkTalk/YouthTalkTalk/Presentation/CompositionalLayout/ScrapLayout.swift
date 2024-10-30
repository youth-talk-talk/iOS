//
//  ScrapLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit

enum MyScrapSection: Int, CaseIterable {
 
    case scrap
    
    static func layout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 17, bottom: 0, trailing: 17)
            section.interGroupSpacing = 12
            
            return section
        }
        
        return layout
    }
}
