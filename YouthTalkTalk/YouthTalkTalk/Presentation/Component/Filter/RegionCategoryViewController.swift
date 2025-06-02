//
//  RegionCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit

final class RegionCategoryViewController: UIViewController {
    // MARK: - Properties
    private let dataSource: [[FilterDetailItem]] = [
        [FilterDetailItem(title: "전체 지역")],
        [
            "서울특별시", "부산광역시", "대구광역시",
            "인천광역시", "광주광역시", "대전광역시",
            "울산광역시", "세종특별자치시", "경기도",
            "충청북도", "충청남도", "전라북도",
            "전라남도", "경상북도", "경상남도", "강원도",
            "제주특별자치도"
        ].map { .init(title: $0) }
    ]
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: FilterCategorySectionLayout.createTwoSectionLayout()
    ).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(FilterDetailCell.self, forCellWithReuseIdentifier: FilterDetailCell.identifier)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    // MARK: - SetupUI
    private func setupLayout() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RegionCategoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.dataSource[section].count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterDetailCell.identifier,
            for: indexPath
        ) as? FilterDetailCell else { return .init() }
        
        cell.configure(with: self.dataSource[indexPath.section][indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RegionCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("cell 선택됨: \(self.dataSource[indexPath.section][indexPath.item])")
    }
}
