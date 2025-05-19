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
        $0.designed(text: "전체 지역", font: .p18Semi)
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
    
    // MARK: 따끈따끈한 새로운 정책 (newPolicy)
    private let newPolicyLabel = UILabel().then {
        $0.designed(text: "따끈따끈한 새로운 정책", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let newPolicyCategories = ["전체", "주거", "교육", "일자리", "복지", "참여"]

    private lazy var newPolicyCategoryCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: NewCategoryCell.self)
    }
    
    private let newPolicyDateLabel = UILabel().then {
        let dateString = DateFormatter().then {
            $0.dateFormat = "yyyy.MM.dd"
        }.string(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
        
        $0.designed(text: "\(dateString) 기준", font: .p14Regular, textColor: .gray80)
    }
    
    private let newPolicyImageView = UIImageView(image: .chevronRight)
    
    private var newPolicyCurrentIndex: Int = 0
    
    private lazy var newPolicyPages: [UIViewController] = []
    
    private lazy var newPolicyPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.didMove(toParent: self)
    }
    
    private let newPolicyPageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .gray90
        pc.pageIndicatorTintColor = .gray40
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    // MARK: 지금뜨는 정책톡톡!
    private let reviewPolicyView = ReviewPolicyView()
    
    // MARK: 청년톡톡 Best
    private let bestTitleLabel = UILabel().then {
        $0.designed(text: "청년톡톡 Best", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let bestArrowImageView = UIImageView(image: .chevronRight)
    
    private lazy var bestStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        popularPolicyArrowImageView.onTapped { [weak self] in
            let vc = PopularPolicyListViewController(policies: self?.viewModel.allPopularPolicies ?? [])
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        newPolicyImageView.onTapped { [weak self] in
            let vc = PopularPolicyListViewController(policies: self?.viewModel.allPopularPolicies ?? [])
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.onReloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.selectionRegionLabel.text = self?.viewModel.myRegion
                self?.popularPolicyCollectionView.reloadData()
                
                // MARK: 새로운 정책 데이터 세팅
                self?.setupPages()
                self?.setupPageControl()
                
                // MARK: 청년톡톡 Best 데이터 세팅
                print("|| \(self?.viewModel.bestPosts)")
                self?.viewModel.bestPosts.forEach { bestPost in
                    let postView = PostView(post: bestPost)
                    self?.bestStackView.addArrangedSubview(postView)
                }
            }
        }
        
        setLayout()
        setTapEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.requestMyInfoAPI { [weak self] region in
            DispatchQueue.main.async {
                self?.selectionRegionLabel.text = region
            }
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setTapEvents() {
        // MARK: 지역 선택
        [regionTipImageView, selectionRegionLabel, regionDownArrowImageView].forEach {
            $0.onTapped { [weak self] in
                guard let self else { return }
                
                let vc = RegionBottomSheetViewController(selectedRegion: selectionRegionLabel.text,
                                                         onRegionTapped: { [weak self] selectedRegion in
                    self?.selectionRegionLabel.text = selectedRegion?.networkName
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
    
    private func setupPages() {
        var chunkedGroups: [[PolicyDTO]] = []
        var startIndex = 0

        while startIndex < viewModel.newPolicies.count {
            let endIndex = min(startIndex + 4, viewModel.newPolicies.count)
            let group = Array(viewModel.newPolicies[startIndex..<endIndex])
            chunkedGroups.append(group)
            startIndex += 4
        }

        newPolicyPages = chunkedGroups.enumerated().map { index, fourData in
            let vc = NewPolicyPageViewController(policies: fourData)
            vc.view.tag = index
            return vc
        }
        
        guard newPolicyPages.count > 0 else { return }
        newPolicyPageViewController.setViewControllers([newPolicyPages[0]], direction: .forward, animated: false)
    }
    
    private func setupPageControl() {
        newPolicyPageControl.numberOfPages = newPolicyPages.count
        newPolicyPageControl.currentPage = 0
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:            return viewModel.categories.count
        case popularPolicyCollectionView:       return viewModel.popularPolicies.count
        case newPolicyCategoryCollectionView:   return newPolicyCategories.count
            
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell: CategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            let category = viewModel.categories[indexPath.row]
            
            cell.setData(categoryImage: category.0, categoryName: category.1.name)
            
            return cell
            
        } else if collectionView == popularPolicyCollectionView {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }

            let policyData = viewModel.popularPolicies[indexPath.row]
            
            cell.setData(policyData)
            
            return cell
        } else if collectionView == newPolicyCategoryCollectionView {
            guard let cell: NewCategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.label.text = newPolicyCategories[indexPath.row]
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let category = viewModel.categories[indexPath.row].1

            let vm = PolicyCollectionViewModel(selectedCategory: category)
            let vc = PolicyCollectionViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

private extension HomeViewController {
    func setLayout() {
        addChild(newPolicyPageViewController)

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
        
        // MARK: 따끈따끈한 새로운 정책 (newPolicy)
        containerView.addSubview(newPolicyLabel)
        containerView.addSubview(newPolicyDateLabel)
        containerView.addSubview(newPolicyCategoryCollectionView)
        containerView.addSubview(newPolicyPageViewController.view)
        containerView.addSubview(newPolicyPageControl)
        
        // MARK: 지금뜨는 정책톡톡!
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
        
        newPolicyLabel.snp.makeConstraints {
            $0.top.equalTo(popularPolicyCollectionView.snp.bottom).offset(moderate(40))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        newPolicyDateLabel.snp.makeConstraints {
            $0.top.equalTo(newPolicyLabel.snp.bottom).offset(6)
            $0.leading.equalTo(newPolicyLabel)
        }
        
        newPolicyCategoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(newPolicyDateLabel.snp.bottom).offset(moderate(10))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(32))
        }
        
        newPolicyPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(newPolicyCategoryCollectionView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(526))
        }
        
        newPolicyPageControl.snp.makeConstraints {
            $0.top.equalTo(newPolicyPageViewController.view.snp.bottom).offset(moderate(20))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderate(6))
        }
        
        reviewPolicyView.snp.makeConstraints {
            $0.top.equalTo(newPolicyPageControl.snp.bottom).offset(moderate(40))
            $0.leading.trailing.equalToSuperview()
        }
        
        bestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(reviewPolicyView.snp.bottom).offset(moderate(40))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        bestArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(bestTitleLabel)
            $0.size.equalTo(moderate(24))
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        bestStackView.snp.makeConstraints {
            $0.top.equalTo(bestTitleLabel.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalTo(bestTitleLabel)
            $0.bottom.equalToSuperview().inset(moderate(30))
        }
    }
}

extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        guard let index = newPolicyPages.firstIndex(of: vc), index > 0 else { return nil }
        return newPolicyPages[index - 1]
    }

    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        guard let index = newPolicyPages.firstIndex(of: vc), index < newPolicyPages.count - 1 else { return nil }
        return newPolicyPages[index + 1]
    }

    func pageViewController(_ pvc: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = pvc.viewControllers?.first,
              let index = newPolicyPages.firstIndex(of: currentVC) else { return }
        
        newPolicyCurrentIndex = index
        newPolicyPageControl.currentPage = index
    }
}
