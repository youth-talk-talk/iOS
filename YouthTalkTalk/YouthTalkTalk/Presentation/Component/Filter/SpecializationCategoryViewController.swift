//
//  SpecializationCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

final class SpecializationCategoryViewController: UIViewController {
    // MARK: - Properties
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: FilterCategorySectionLayout.createFourGridSectionWithHeaderLayout()
    ).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(FilterDetailCell.self, forCellWithReuseIdentifier: FilterDetailCell.identifier)
        $0.register(
            SpecializationCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SpecializationCategoryHeaderView.identifier
        )
        $0.allowsMultipleSelection = true
    }
    
    private var dataSource: [SpecializationCategoryDataSource] = [
        .init(section: .occupationAndIndustry, items: ["전체 선택", "중소기업", "농업인", "군인"]
            .map { .init(title: $0)} ),
        .init(section: .vulnerableGroups, items: ["전체 선택", "여성", "기초생활수급자", "장애인", "한무보 가정"]
            .map { .init(title: $0)} ),
        .init(section: .others, items: ["전체 선택", "지역인재", "기타"]
            .map { .init(title: $0)} ),
        .init(section: .maritalStatus, items: ["제한 없음", "미혼", "기혼"]
            .map { .init(title: $0)} )
    ]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - SetupUI
    private func setupLayout() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SpecializationCategoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.dataSource[section].items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterDetailCell.identifier,
            for: indexPath
        ) as? FilterDetailCell else { return .init() }
        
        cell.configure(with: self.dataSource[indexPath.section].items[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SpecializationCategoryHeaderView.identifier,
            for: indexPath
           ) as? SpecializationCategoryHeaderView {
            headerView.configure(text: self.dataSource[indexPath.section].section.title)
            return headerView
        }
        return .init()
    }
}

// MARK: - UICollectionViewDelegate
extension SpecializationCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let isAllSelect = (indexPath.item == 0)
        if isAllSelect {
            // 해당 section의 전체 선택 클릭 시: 나머지 태그 선택 해제, 전체만 선택
            let itemCount = dataSource[indexPath.section].items.count
            for item in 1..<itemCount {
                let otherIndexPath = IndexPath(item: item, section: indexPath.section)
                collectionView.deselectItem(at: otherIndexPath, animated: false)
            }
            // 전체 선택만 남기기
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            // 나머지 태그 클릭 시: 해당 section의 전체 선택 해제
            let allSelectIndexPath = IndexPath(item: 0, section: indexPath.section)
            collectionView.deselectItem(at: allSelectIndexPath, animated: false)
        }
    }
}
