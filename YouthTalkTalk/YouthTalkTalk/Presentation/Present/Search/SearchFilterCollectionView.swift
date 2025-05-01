//
//  SearchFilterCollectionView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/29/25.
//

import UIKit

final class SearchFilterCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        collectionViewLayout = createLayout()
        
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1.0),
            heightDimension: .absolute(32)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 16,
                                                        bottom: 0,
                                                        trailing: 16)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
}

