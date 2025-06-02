//
//  FilterCategorySectionLayout.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit

final class FilterCategorySectionLayout {
    // MARK: - Create Layout
    static func createTwoSectionLayout(
        gridSectionContentInsets: NSDirectionalEdgeInsets = .init(
            top: 0,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
    ) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                /// 1 Row, 1 Column section
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(12)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20,
                    leading: 20,
                    bottom: 12,
                    trailing: 20
                )
                return section
            case 1:
                return gridSection(contentInset: gridSectionContentInsets)
            default:
                return nil
            }
        }
    }
     
    static func createOneSectionGridLayout(
        gridSectionContentInsets: NSDirectionalEdgeInsets = .init(
            top: 0,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
    ) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                return gridSection(contentInset: gridSectionContentInsets)
            default:
                return nil
            }
        }
    }
    
    static func createFourGridSectionWithHeaderLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            let header = self.sectionHeader()
            switch section {
            case 0, 1, 2, 3:
                let section = gridSection(contentInset: .init(top: 10, leading: 20, bottom: 20, trailing: 20))
                section.boundarySupplementaryItems = [header]
            
                
                
                
                return section
            default:
                return nil
            }
        }
    }
    
    // MARK: - Helper
    
    /// N Row, M Column section
    static func gridSection(
        contentInset: NSDirectionalEdgeInsets
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInset
        section.interGroupSpacing = 12
        return section
    }
    
    static func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        return header
    }
}
