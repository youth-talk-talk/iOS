//
//  DetailFilterBottomSheetViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/30/25.
//

import UIKit

final class DetailFilterBottomSheetViewController: UIViewController {
    
    private let filters = ["정책분야", "지역", "취업상태", "학력", "특화 분야", "연령 및 소득"]
    
    private let grabView = GrabView()
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "필터", font: .p16SemiBold)
    }

    // 필터 제목
    private let filterTitleScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    
    private let filterTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    private var filterTitleLabels: [UILabel] = []
    
    // 현재 필터 페이지 표시 바
    private let indicatorBar = UIView().then {
        $0.backgroundColor = .greenNormal
    }

    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.didMove(toParent: self)
        $0.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    private lazy var pages: [UIViewController] = filters.map { DetailFilterViewController(filterTitle: $0) }
    
    private let resetStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.alignment = .center
    }
    
    private let resetLabel = UILabel().then {
        $0.designed(text: "초기화", font: .p16Regular16, textColor: .gray70)
    }
    
    private let resetImageView = UIImageView(image: .refresh)
    
    private let applyButton = UIButton().then {
        $0.designed(title: "적용하기")
        $0.isEnabled = false
    }
    
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.roundTopCorners(radius: 20)
        
        setLayout()
        setupFilterTitles()
        setupIndicatorBar()
    }

    private func setupFilterTitles() {
        for (index, title) in filters.enumerated() {
            let filterLabel = UILabel().then {
                if index == 0 {
                    $0.designed(text: title, font: .p14Bold, textColor: .green)
                    
                } else {
                    $0.designed(text: title, font: .p14Regular, textColor: .gray70)
                }
            }
            
            filterLabel.onTapped { [weak self] in
                guard let self else { return }
                
                let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
                pageViewController.setViewControllers([pages[index]], direction: direction, animated: true)
                
                currentIndex = index
                moveIndicator(to: filterLabel)
            }
            
            filterTitleStackView.addArrangedSubview(filterLabel)
            filterTitleLabels.append(filterLabel)
        }
    }

    private func setupIndicatorBar() {
        guard let firstLabel = filterTitleLabels.first else { return }
        
        indicatorBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.height.equalTo(2)
            $0.width.equalTo(firstLabel)
            $0.centerX.equalTo(firstLabel)
        }
    }

    private func moveIndicator(to label: UILabel) {
        filterTitleLabels.forEach {
            if $0 == label {
                $0.designed(text: $0.text ?? "", font: .p14Bold, textColor: .green)
                
            } else {
                $0.designed(text: $0.text ?? "", font: .p14Regular, textColor: .gray70)
            }
        }
        
        indicatorBar.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.height.equalTo(2)
            $0.width.equalTo(label)
            $0.centerX.equalTo(label)
        }

        UIView.animate(withDuration: 0.25) {
            self.filterTitleScrollView.layoutIfNeeded()
        }
    }
    
    private func setLayout() {
        addChild(pageViewController)
        
        view.addSubview(grabView)
        view.addSubview(titleLabel)
        view.addSubview(pageViewController.view)
        view.addSubview(filterTitleScrollView)
        view.addSubview(resetStackView)
        view.addSubview(applyButton)
        
        resetStackView.addArrangedSubview(resetLabel)
        resetStackView.addArrangedSubview(resetImageView)
        
        filterTitleScrollView.addSubview(filterTitleStackView)
        filterTitleScrollView.addSubview(indicatorBar)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grabView).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        filterTitleScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        filterTitleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(filterTitleScrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(resetStackView.snp.top).offset(moderate(-26))
        }
        
        resetStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderate(26))
            $0.height.equalTo(moderate(46))
            $0.leading.equalToSuperview().inset(28.5)
            $0.trailing.equalTo(applyButton.snp.leading).offset(moderate(-22.5))
        }
        
        applyButton.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview().dividedBy(1.5)
            $0.height.equalTo(moderate(46))
            $0.trailing.equalToSuperview().inset(moderate(20))
            $0.bottom.equalTo(resetStackView)
        }
        
        resetImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(16))
        }
    }
}

extension DetailFilterBottomSheetViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
        moveIndicator(to: filterTitleLabels[index])
    }
}

extension DetailFilterBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return moderate(16)
    }
}
