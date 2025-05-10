//
//  PolicyCollectionViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/10/25.
//

import UIKit

final class PolicyCollectionViewController: RootViewController {
    
    // MARK: 정책 카테고리
    private(set) var filters: [String] = ["정책분야", "지역", "취업상태", "학력", "특화 분야", "연령 및 소득"]
    private let categoryCellSize = CGSize(width: moderate(64), height: moderate(94))
    private lazy var categoryCollectionView = makeCollectionView(categoryCellSize).then {
        $0.register(cells: CategoryCell.self)
    }
    
    // MARK: 검색 결과 필터
    private(set) var categories: [(UIImage, String)] = [(.total, "전체"),
                                                        (.home, "주거"),
                                                        (.education, "교육"),
                                                        (.work, "일자리"),
                                                        (.culture, "복지"),
                                                        (.apply, "참여 권리")]
    private lazy var searchFilterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: SearchFilterCell.self)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let resultCountLabel = UILabel().then {
        $0.designed(text: "총 0건", font: .p14Regular)
    }
    
    // MARK: 정책 리스트
    private let popularPolicyCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32), height: moderate(121))
    private lazy var policyCollectionView = makeCollectionView(popularPolicyCellSize, direction: .vertical).then {
        $0.register(cells: PolicyCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuTitle("정책 모아보기")
        
        view.addSubviews(categoryCollectionView,
                         searchFilterCollectionView,
                         dividerView,
                         resultCountLabel,
                         policyCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(94))
        }
        
        searchFilterCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            $0.left.trailing.equalToSuperview()
            $0.height.equalTo(moderate(32))
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(searchFilterCollectionView.snp.bottom).offset(moderate(15))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(1))
        }
        
        resultCountLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.top).offset(moderate(10))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        policyCollectionView.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom).offset(moderate(10))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeCollectionView(_ itemSize: CGSize, direction: UICollectionView.ScrollDirection = .horizontal) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = direction
            layout.itemSize = itemSize

            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.contentInset.left = 16
            $0.contentInset.right = 16
            $0.showsHorizontalScrollIndicator = false
        }
        
        return collectionView
    }
}

extension PolicyCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchFilterCollectionView {
            return filters.count
            
        } else if collectionView == categoryCollectionView {
            return categories.count
            
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchFilterCollectionView {
            guard let cell: SearchFilterCell = collectionView.dequeueCell(for: indexPath) else { return .init() }
            
            let filterTitle = filters[indexPath.row]
            
            cell.setTitle(filterTitle)
            
            cell.onTapped { [weak self] in
                let vc = DetailFilterBottomSheetViewController()
                
                if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
                
                self?.present(vc, animated: true, completion: nil)
            }
            
            return cell
            
        } else if collectionView == categoryCollectionView {
            guard let cell: CategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            let category = categories[indexPath.row]
            
            cell.setData(categoryImage: category.0, categoryName: category.1)
            
            return cell
            
        } else {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.setStyle(.border)
//            cell.setData(.)

            return cell
        }
    }
}
