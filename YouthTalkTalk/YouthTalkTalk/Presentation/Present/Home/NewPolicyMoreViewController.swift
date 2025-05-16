//
//  NewPolicyMoreViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/15/25.
//

import UIKit

final class NewPolicyMoreViewController: RootViewController {
    
    private let filters = ["전체", "주거", "교육", "일자리", "복지", "참여"]

    private lazy var filterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: NewCategoryCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuTitle("최근 올라온 정책")
        
        filterCollectionView.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(32))
        }
    }
}

extension NewPolicyMoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: NewCategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.label.text = filters[indexPath.row]
        
        return cell
    }
}
