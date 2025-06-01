//
//  PopularPolicyListViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

final class PopularPolicyListViewController: RootViewController {
    private let policies: [PolicyDTO]
    
    private lazy var titleLabel = UILabel().then {
        $0.designed(text: "우리지역 인기 정책", font: .p18Semi)
    }
    
    private let popularPolicyCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32), height: moderate(121))
    private lazy var popularPolicyCollectionView = makeCollectionView(popularPolicyCellSize).then {
        $0.register(cells: PolicyCell.self)
    }
    
    init(policies: [PolicyDTO]) {
        self.policies = policies
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(popularPolicyCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        popularPolicyCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(20))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeCollectionView(_ itemSize: CGSize) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = itemSize

            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.contentInset.top = moderate(10)
            $0.contentInset.left = moderate(16)
            $0.contentInset.right = moderate(16)
            $0.contentInset.bottom = moderate(16)
            $0.showsVerticalScrollIndicator = false
        }
        
        return collectionView
    }
}

extension PopularPolicyListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return policies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.setData(policies[indexPath.row])
        cell.setStyle(.border)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let policyId = policies[indexPath.row].policyId
        let vc = PolicyDetailViewController(policyId: String(policyId))
        navigationController?.pushViewController(vc, animated: true)
    }
}
