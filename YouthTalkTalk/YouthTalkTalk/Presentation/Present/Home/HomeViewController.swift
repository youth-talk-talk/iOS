//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let baseScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let containerView = UIView()
    
    // MARK: 지역 선택 & 검색
    private let regionTipImageView = UIImageView(image: .locationTip)
    
    private let selectionRegionLabel = UILabel().then {
        $0.designed(text: "서울", font: .p18Semi)
    }
    
    private let regionDownArrowImageView = UIImageView(image: .arrowDown.withTintColor(.black))
    
    private let searchImageView = UIImageView(image: .search)
    
    // MARK: 정책 카테고리
    private let categoryCellSize = CGSize(width: 64, height: 94)
    private lazy var categoryCollectionView = makeCollectionView(categoryCellSize).then {
        $0.register(cells: CategoryCell.self)
    }
    
    // MARK: 우리 지역 인기 정책
    private let popularPolicyLabel = UILabel().then {
        $0.designed(text: "우리 지역 인기 정책", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let popularPolicyArrowImageView = UIImageView(image: .chevronRight)
    
    private let popularPolicyCellSize = CGSize(width: UIScreen.main.bounds.width - 35, height: 152)
    private lazy var popularPolicyCollectionView = makeCollectionView(popularPolicyCellSize).then {
        $0.register(cells: PolicyCell.self)
    }
    
    // MARK: 실시간 정책 톡톡!
    private let reviewPolicyView = ReviewPolicyView()
    
    // MARK: 청년톡톡 Best
    private let bestTitleLabel = UILabel().then {
        $0.designed(text: "청년톡톡 Best", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let bestArrowImageView = UIImageView(image: .chevronRight)
    
    private lazy var bestStackView = UIStackView(arrangedSubviews: [bestPostView1,
                                                                    bestPostView2]).then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private let bestPostView1 = PostView()
    private let bestPostView2 = PostView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: fetchMe 하고 userDefaults에 저장해두기 그걸로 내 지역 세팅
        view.backgroundColor = .white
        
        popularPolicyArrowImageView.onTapped { [weak self] in
            let vc = PopularPolicyListViewController(policies: self?.viewModel.allPopularPolicies ?? [])
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.onReloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.popularPolicyCollectionView.reloadData()
            }
        }
        
        setLayout()
        setTapEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setTapEvents() {
        // MARK: 지역 선택
        [regionTipImageView, selectionRegionLabel, regionDownArrowImageView].forEach {
            $0.onTapped { [weak self] in
                guard let self else { return }
                
                let vc = RegionBottomSheetViewController(selectedRegion: selectionRegionLabel.text,
                                                         onRegionTapped: { [weak self] selectedRegion in
                    self?.selectionRegionLabel.text = selectedRegion
                })
                
                if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
                
                present(vc, animated: true, completion: nil)
            }
        }
        
        searchImageView.onTapped { [weak self] in
            let searchVC = SearchViewController()
            self?.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    private func makeCollectionView(_ itemSize: CGSize) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:        return viewModel.categories.count
        case popularPolicyCollectionView:   return viewModel.popularPolicies.count
            
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell: CategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            let category = viewModel.categories[indexPath.row]
            
            cell.setData(categoryImage: category.0, categoryName: category.1)
            
            return cell
            
        } else if collectionView == popularPolicyCollectionView {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }

            let policyData = viewModel.popularPolicies[indexPath.row]
            
            cell.setData(policyData)
            
            return cell
        } else {
            return .init()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case categoryCollectionView:        return 20
        case popularPolicyCollectionView:   return 14
            
        default: return 0
        }
    }
}

private extension HomeViewController {
    
    func setLayout() {
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(containerView)
        
        // MARK: 지역 설정 & 검색
        containerView.addSubview(regionTipImageView)
        containerView.addSubview(selectionRegionLabel)
        containerView.addSubview(regionDownArrowImageView)
        containerView.addSubview(searchImageView)
        
        // MARK: 정책 카테고리
        containerView.addSubview(categoryCollectionView)
        
        // MARK: 우리 지역 인기 정책
        containerView.addSubview(popularPolicyLabel)
        containerView.addSubview(popularPolicyArrowImageView)
        containerView.addSubview(popularPolicyCollectionView)
        
        // MARK: 실시간 정책 톡톡!
        containerView.addSubview(reviewPolicyView)
        
        // MARK: 청년톡톡 Bset
        containerView.addSubview(bestTitleLabel)
        containerView.addSubview(bestArrowImageView)
        containerView.addSubview(bestStackView)
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        regionTipImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        selectionRegionLabel.snp.makeConstraints {
            $0.centerY.equalTo(regionTipImageView)
            $0.leading.equalTo(regionTipImageView.snp.trailing).offset(2)
        }
        
        regionDownArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(regionTipImageView)
            $0.leading.equalTo(selectionRegionLabel.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(regionTipImageView)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(regionTipImageView.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(94)
        }
        
        popularPolicyLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(14)
        }
        
        popularPolicyArrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(24)
            $0.centerY.equalTo(popularPolicyLabel)
        }
        
        popularPolicyCollectionView.snp.makeConstraints {
            $0.top.equalTo(popularPolicyArrowImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        reviewPolicyView.snp.makeConstraints {
            $0.top.equalTo(popularPolicyCollectionView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
        
        bestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(reviewPolicyView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        bestArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(bestTitleLabel)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        bestStackView.snp.makeConstraints {
            $0.top.equalTo(bestTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(bestTitleLabel)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
}
