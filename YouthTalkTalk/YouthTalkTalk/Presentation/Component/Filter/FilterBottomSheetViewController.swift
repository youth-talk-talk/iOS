//
//  FilterBottomSheetViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class FilterBottomSheetViewController: UIViewController {
    // MARK: - Properties
    private let indicatorView = UIView().then {
        $0.backgroundColor = .gray50
    }
    
    private let titleLabel = UILabel().then {
        $0.font = FontManager.font(.p16SemiBold)
        $0.text = "필터"
        $0.textColor = .gray100
    }
    
    private let categories = ["정책분야", "지역", "학력", "취업상태", "특화 분야", "연령 및 소득"]
    
    private let categoryScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    private var categoryLabels: [UILabel] = []
    
    private let grayLineView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    private let selectedBar = UIView().then {
        $0.backgroundColor = .greenNormal
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private lazy var pages: [UIViewController] = categories.map { category in
        switch category {
        case "정책분야": return PolicyFieldCategoryViewController()
        case "지역": return RegionCategoryViewController()
        case "학력": return EducationCategoryViewController()
        case "취업상태": return EmploymentStatusCategoryViewController()
        case "특화 분야": return SpecializationCategoryViewController()
        case "연령 및 소득": return AgeAndIncomeCategoryViewController()
        default: return UIViewController()
        }
        
    }
    
    private var currentIndex: Int
    
    // Bottom Buttons
    private let resetButton = UIButton(type: .system).then {
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.gray70, for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.tintColor = .gray40
        $0.setImage(UIImage(named: "Refresh"), for: .normal)
    }
    private let applyButton = UIButton(type: .system).then {
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.gray70, for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16SemiBold)
        $0.backgroundColor = .gray30
        $0.layer.cornerRadius = 6
        $0.isEnabled = false
    }
    private let bottomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    // MARK: - LifeCycle
    init(currentIndex: Int = 0) {
        self.currentIndex = currentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupCategories()
        setupPageViewController()
        setupIndicatorBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.layer.cornerRadius = indicatorView.bounds.height * 0.7
    }
    
    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(indicatorView)
        view.addSubview(titleLabel)
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        view.addSubview(grayLineView)
        view.addSubview(selectedBar)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        indicatorView.snp.makeConstraints {
            $0.width.equalTo(moderate(50))
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        categoryStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        grayLineView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        // 하단 버튼 StackView 추가
        bottomButtonStackView.addArrangedSubview(resetButton)
        bottomButtonStackView.addArrangedSubview(applyButton)
        view.addSubview(bottomButtonStackView)
        resetButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(85)
        }
        applyButton.snp.makeConstraints {
            $0.width.equalTo(236)
            $0.height.equalTo(44)
        }
        bottomButtonStackView.snp.makeConstraints {
            $0.top.equalTo(pageViewController.view.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(46)
        }
    }
    
    // MARK: - Actions
    @objc private func categoryTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        let index = label.tag
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[index]], direction: direction, animated: true)
        updateCategorySelection(to: index)
        scrollToCategory(at: index)
    }
    
    // MARK: - Private
    private func setupCategories() {
        for (index, title) in categories.enumerated() {
            let label = UILabel()
            label.text = title
            label.font = index == 0 ? FontManager.font(.p14SemiBold) : FontManager.font(.p14Regular)
            label.textColor = index == 0 ? .greenNormal : .gray70
            label.isUserInteractionEnabled = true
            label.tag = index
            label.textAlignment = .center
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped(_:)))
            label.addGestureRecognizer(tap)
            
            label.snp.makeConstraints { $0.height.equalTo(40) }
            categoryStackView.addArrangedSubview(label)
            categoryLabels.append(label)
        }
    }
    
    private func setupPageViewController() {
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func setupIndicatorBar() {
        guard let firstLabel = categoryLabels.first else { return }
        
        selectedBar.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(2)
            $0.height.equalTo(2)
            $0.width.equalTo(firstLabel)
            $0.centerX.equalTo(firstLabel)
        }
    }
    
    private func updateCategorySelection(to index: Int) {
        for (i, label) in categoryLabels.enumerated() {
            label.font = i == index ? FontManager.font(.p14SemiBold) : FontManager.font(.p14Regular)
            label.textColor = i == index ? .greenNormal : .gray70
        }
        
        currentIndex = index
        let selectedLabel = categoryLabels[index]
        selectedBar.snp.remakeConstraints {
            $0.bottom.equalTo(grayLineView.snp.top)
            $0.height.equalTo(3)
            $0.width.equalTo(selectedLabel.snp.width)
            $0.centerX.equalTo(selectedLabel)
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func scrollToCategory(at index: Int) {
        guard !categoryLabels.isEmpty else { return }
        let label = categoryLabels[index]
        let labelFrame = label.convert(label.bounds, to: categoryScrollView)
        let scrollViewWidth = categoryScrollView.bounds.width
        let contentWidth = categoryScrollView.contentSize.width
        
        var targetX: CGFloat
        
        if index == 0 {
            // 첫 번째 버튼: 왼쪽 끝
            targetX = 0
        } else if index == categoryLabels.count - 1 {
            // 마지막 버튼: 오른쪽 끝
            targetX = max(0, contentWidth - scrollViewWidth)
        } else {
            // 중간 버튼: 중앙에 오도록
            targetX = labelFrame.midX - scrollViewWidth / 2
            targetX = max(0, min(targetX, contentWidth - scrollViewWidth))
        }
        
        categoryScrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension FilterBottomSheetViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        
        return pages[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension FilterBottomSheetViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed, let currentVC = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: currentVC) else { return }
        
        updateCategorySelection(to: index)
        scrollToCategory(at: index)
    }
}
