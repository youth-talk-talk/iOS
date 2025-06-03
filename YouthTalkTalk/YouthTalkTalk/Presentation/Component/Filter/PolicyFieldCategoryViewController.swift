//
//  PolicyFieldCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

// MARK: - 정책분야
final class PolicyFieldCategoryViewController: UIViewController {
    
    
    // MARK: - Properties
    private let dataSource: [[FilterDetailItem]] = [
        [FilterDetailItem(title: "전체 선택")],
        ["주거", "교육", "일자리", "복지", "참여"].map { .init(title: $0) }
    ]
    
    private var selectedIndexPaths: Set<IndexPath> = []
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: FilterCategorySectionLayout.createTwoSectionLayout()
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
extension PolicyFieldCategoryViewController: UICollectionViewDataSource {
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
extension PolicyFieldCategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let isAllSelect = (indexPath.section == 0)
        
        if isAllSelect {
            // 전체 선택 클릭 시: 나머지 태그 선택 해제, 전체만 선택
            for item in 0..<dataSource[1].count {
                let otherIndexPath = IndexPath(item: item, section: 1)
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
