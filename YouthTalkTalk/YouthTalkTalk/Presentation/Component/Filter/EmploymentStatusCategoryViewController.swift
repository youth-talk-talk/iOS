//
//  EmploymentStatusCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

final class EmploymentStatusCategoryViewController: UIViewController {
    private let dataSource: [FilterDetailItem] = [
        "전체 선택", "재직자", "자영업자", "미취업자",
        "프리랜서", "일용근로자", "예비창업자",
        "단기근로자", "영농종사자", "기타"
    ].map { .init(title: $0) }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: FilterCategorySectionLayout.createOneSectionGridLayout(
            gridSectionContentInsets: .init(
                top: 20,
                leading: 20,
                bottom: 20,
                trailing: 20
            )
        )
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
extension EmploymentStatusCategoryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.dataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterDetailCell.identifier,
            for: indexPath
        ) as? FilterDetailCell else { return .init() }
        
        cell.configure(with: self.dataSource[indexPath.item])
        return cell
    }
}

// MARK: - EmploymentStatusCategoryViewController
extension EmploymentStatusCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("cell 선택됨: \(self.dataSource[indexPath.item])")
    }
}

