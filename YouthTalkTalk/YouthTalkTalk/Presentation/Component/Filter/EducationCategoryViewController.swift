//
//  EducationCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

final class EducationCategoryViewController: UIViewController {
    private let dataSource: [FilterDetailItem] = [
        "전체 선택", "고졸 미만", "고교 재학",
        "고졸 예정", "고교 졸업", "대학 재학",
        "대졸 예정", "대학 졸업", "석박사"
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
        $0.allowsMultipleSelection = true
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
extension EducationCategoryViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionViewDelegate
extension EducationCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let isAllSelect = (indexPath.item == 0)
        if isAllSelect {
            // 전체 선택 클릭 시: 나머지 태그 선택 해제, 전체만 선택
            for item in 1..<dataSource.count {
                let otherIndexPath = IndexPath(item: item, section: 0)
                collectionView.deselectItem(at: otherIndexPath, animated: false)
            }
            // 전체 선택만 남기기
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            // 나머지 태그 클릭 시: 전체 선택 해제
            let allSelectIndexPath = IndexPath(item: 0, section: 0)
            collectionView.deselectItem(at: allSelectIndexPath, animated: false)
        }
    }
}
