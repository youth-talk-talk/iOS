//
//  PolicyCollectionViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/10/25.
//

import UIKit

final class PolicyCollectionViewController: RootViewController {
    
    private let viewModel: PolicyCollectionViewModel
        
    // MARK: 정책 카테고리
    private let categoryCellSize = CGSize(width: moderate(64), height: moderate(94))
    private lazy var categoryCollectionView = makeCollectionView(categoryCellSize).then {
        $0.register(cells: CategoryCell.self)
    }
    
    // MARK: 검색 결과 필터
    private lazy var searchFilterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: SearchFilterCell.self)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let resultCountLabel = UILabel().then {
        $0.designed(font: .p14Regular)
    }
    
    // MARK: 정책 리스트
    private let popularPolicyCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32), height: moderate(121))
    private lazy var policyCollectionView = makeCollectionView(popularPolicyCellSize, direction: .vertical).then {
        $0.register(cells: PolicyCell.self)
    }
    
    init(viewModel: PolicyCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuTitle("정책 모아보기")
        
        viewModel.onReloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.resultCountLabel.text = "총 \(self?.viewModel.policies.count ?? 0)건"
                self?.policyCollectionView.reloadData()
            }
        }
        
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
            $0.showsVerticalScrollIndicator = false
        }
        
        return collectionView
    }
}

extension PolicyCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchFilterCollectionView {
            return viewModel.filters.count
            
        } else if collectionView == categoryCollectionView {
            return viewModel.categories.count
            
        } else {
            return viewModel.policies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchFilterCollectionView {
            guard let cell: SearchFilterCell = collectionView.dequeueCell(for: indexPath) else { return .init() }
            
            let filterTitle = viewModel.filters[indexPath.row].rawValue
            
            cell.setTitle(filterTitle)
            
            cell.onTapped { [weak self] in
                let vc = FilterBottomSheetViewController(currentIndex: indexPath.item)
                
              if let sheet = vc.sheetPresentationController { sheet.detents = [.custom { _ in 572 }] }
                
                self?.present(vc, animated: true, completion: nil)
            }
            
            return cell
            
        } else if collectionView == categoryCollectionView {
            guard let cell: CategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            let category = viewModel.categories[indexPath.row]
            let isSelected = (category.1 == viewModel.selectedCategory)
            
            cell.setData(categoryImage: category.0, categoryName: category.1.name, isSelected: isSelected)
            
            return cell
            
        } else {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            let policy = viewModel.policies[indexPath.row]
            
            cell.setStyle(.border)
            cell.setData(policy)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            viewModel.didTapCategory(index: indexPath.row)
            categoryCollectionView.reloadData()
        }
    }
}
