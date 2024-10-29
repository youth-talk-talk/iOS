//
//  MyPageLayout.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit

enum MyPageSection: Int, CaseIterable {
    
    case policy
    case favorite
    
    var title: String {
        
        switch self {
        case .policy:
            return "마감 D-day"
        case .favorite:
            return "즐겨찾기"
        }
    }
    
    static func layout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = MyPageSection(rawValue: section) ?? .policy
            
            switch section {
            case .policy:
                return policyLayout()
            case .favorite:
                return favoriteLayout()
            }
        }
        
        layout.register(RadiusCollectionReusableView.self,
                        forDecorationViewOfKind: RadiusCollectionReusableView.identifier)
        
        return layout
    }
}

extension MyPageSection {
    
    static func policyLayout() -> NSCollectionLayoutSection {
        
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17)
        
        // 섹션 좌우 여백 설정 (좌우 여백 20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = -5
        
        // 헤더 사이즈 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(48)  // 헤더 높이 설정
        )
        
        // 헤더 생성
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: TitleHeaderView.identifier,
            alignment: .top
        )
        
        // 헤더를 섹션에 추가
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 13, trailing: 17)
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: RadiusCollectionReusableView.identifier)
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    static func favoriteLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 섹션 좌우 여백 설정 (좌우 여백 20)
        let section = NSCollectionLayoutSection(group: group)
        
        // 헤더 사이즈 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(48)  // 헤더 높이 설정
        )
        
        // 헤더 생성
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: TitleHeaderView.identifier,
            alignment: .top
        )
        
        // 헤더를 섹션에 추가
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 17, bottom: 12, trailing: 17)
        
        return section
    }
}
