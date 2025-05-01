//
//  PolicyMainViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class PolicyMainViewController: UIViewController {
    private let viewModel = PolicyMainViewModel()
    
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
    
    // MARK: 최근 본 정책
    private let seePolicyLabel = UILabel().then {
        $0.designed(text: "최근 본 정책", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let seePolicyArrowImageView = UIImageView(image: .chevronRight)
    
    private let seePolicyCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(75),
                                           height: moderate(123))
    private lazy var seePolicyCollectionView = makeCollectionView(seePolicyCellSize).then {
        $0.register(cells: PolicyCell.self)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    // MARK: 곧 마감되는 정책
    private let endPolicyHeaderView = TitleArrowView(text: "곧 마감되니 서둘러 지원해 보세요!")
    
    private let endPolicyCellSize = CGSize(width: moderate(40),
                                           height: moderate(66))
    private lazy var endPolicyCollectionView = makeCollectionView(endPolicyCellSize).then {
        $0.register(cells: PolicyDateCell.self)
    }
    
    private let endPolicyListCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32),
                                               height: moderate(123))
    private lazy var endPolicyListCollectionView = makeCollectionView(endPolicyListCellSize, direction: .vertical).then {
        $0.register(cells: PolicyCell.self)
        $0.isScrollEnabled = false
    }
    
    private let dividerView2 = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    // MARK: 주제별 신규 정책
    private let newManyPolicyHeaderView = TitleArrowView(text: "주제별 다양한 정책을 만나보세요")
    
    private lazy var newManyPolicyFilterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: PolicyCategoryCell.self)
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.didMove(toParent: self)
        $0.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    private let filters = ["전체", "주거", "교육", "일자리", "복지", "참여", "똥"]
    private lazy var pages: [UIViewController] = filters.map { _ in PolicyPageViewController() }
    
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        addChild(pageViewController)
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(containerView)
        
        // 지역 설정 & 검색
        containerView.addSubview(regionTipImageView)
        containerView.addSubview(selectionRegionLabel)
        containerView.addSubview(regionDownArrowImageView)
        containerView.addSubview(searchImageView)
        
        // 최근 본 정책
        containerView.addSubview(seePolicyLabel)
        containerView.addSubview(seePolicyArrowImageView)
        containerView.addSubview(seePolicyCollectionView)
        containerView.addSubview(dividerView)
        
        // 곧 마감되는 정책
        containerView.addSubview(endPolicyHeaderView)
        containerView.addSubview(endPolicyCollectionView)
        containerView.addSubview(endPolicyListCollectionView)
        containerView.addSubview(dividerView2)
        
        // 주제별 신규 정책
        containerView.addSubview(newManyPolicyHeaderView)
        containerView.addSubview(newManyPolicyFilterCollectionView)
        containerView.addSubview(pageViewController.view)

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
        
        seePolicyLabel.snp.makeConstraints {
            $0.top.equalTo(regionTipImageView.snp.bottom).offset(moderate(25))
            $0.leading.equalTo(regionTipImageView)
        }
        
        seePolicyArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(seePolicyLabel)
            $0.size.equalTo(moderate(24))
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        seePolicyCollectionView.snp.makeConstraints {
            $0.top.equalTo(seePolicyLabel.snp.bottom).offset(moderate(14))
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(moderate(123))
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(seePolicyCollectionView.snp.bottom).offset(moderate(30))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(10))
        }
        
        endPolicyHeaderView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
        }
        
        endPolicyCollectionView.snp.makeConstraints {
            $0.top.equalTo(endPolicyHeaderView.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(66))
        }
        
        endPolicyListCollectionView.snp.makeConstraints {
            $0.top.equalTo(endPolicyCollectionView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(540)
        }
        
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(endPolicyListCollectionView.snp.bottom).offset(moderate(30))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(10))
        }
        
        newManyPolicyHeaderView.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview()
        }
        
        newManyPolicyFilterCollectionView.snp.makeConstraints {
            $0.top.equalTo(newManyPolicyHeaderView.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(32))
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(newManyPolicyFilterCollectionView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(540))
            $0.bottom.equalToSuperview().inset(moderate(30))
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

extension PolicyMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == endPolicyListCollectionView {
            return 4
        } else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == seePolicyCollectionView || collectionView == endPolicyListCollectionView {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.setStyle(.border)
            
            return cell
        } else if collectionView == newManyPolicyFilterCollectionView {
            guard let cell: PolicyCategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.label.text = filters[indexPath.row]
            
            return cell
            
        } else {
            guard let cell: PolicyDateCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.changeGreen(indexPath.row == 0)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == seePolicyCollectionView || collectionView == endPolicyListCollectionView {
            return moderate(16)
            
        } else {
            return moderate(10)
        }
    }
}

extension PolicyMainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: vc), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: vc), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pvc: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = pvc.viewControllers?.first,
              let index = pages.firstIndex(of: currentVC) else { return }
        currentIndex = index
    }
}
