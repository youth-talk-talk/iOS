//
//  CommunityMainViewcontroller.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit
import SnapKit

final class CommunityMainViewcontroller: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "커뮤니티", font: .p18Semi)
    }
    
    // MARK: 검색 바
    private let searchBarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.backgroundColor = .gray30
        $0.layer.cornerRadius = moderate(6)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: moderate(10), left: moderate(14), bottom: moderate(10), right: moderate(10))
    }
    
    private let searchImageView = UIImageView(image: .search.withTintColor(.gray70))
    
    private let searchLabel = UILabel().then {
        $0.designed(text: "궁금한 주제가 있나요?", font: .p16Regular16, textColor: .gray70)
    }
    
    // MARK: 후기 / 자유 탭
    private let reviewLabel = UILabel().then {
        $0.designed(text: "후기게시판", font: .p14Bold)
        $0.textAlignment = .center
    }
    
    private let freeLabel = UILabel().then {
        $0.designed(text: "자유게시판", font: .p14Regular, textColor: .gray70)
        $0.textAlignment = .center
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let writePostView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(8)
        $0.backgroundColor = .greenNormal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: moderate(16), bottom: 0, right: moderate(16))
        $0.layer.cornerRadius = moderate(21)
        $0.alignment = .center
    }
    
    private let writeImageView = UIImageView(image: .writePencil.withTintColor(.white))
    
    private let writeLabel = UILabel().then {
        $0.designed(text: "글쓰기", font: .p16Regular16, textColor: .white)
    }
    
    private var currentIndex: Int = 0
    private lazy var pages: [UIViewController] = [CommunityPageViewController(), CommunityPageViewController()]
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.didMove(toParent: self)
        $0.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        searchBarStackView.onTapped { [weak self] in
            let searchVC = SearchViewController()
            self?.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        reviewLabel.onTapped { [weak self] in
            self?.moveIndicator(to: self!.reviewLabel)
        }
        
        freeLabel.onTapped { [weak self] in
            self?.moveIndicator(to: self!.freeLabel)
        }
        
        writePostView.onTapped { [weak self] in
            let vc = CreatePostViewController(postType: .review)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    private func moveIndicator(to label: UILabel) {
        let index = (label == reviewLabel) ? 0 : 1
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[index]], direction: direction, animated: true)
        
        currentIndex = index
        
        [reviewLabel, freeLabel].forEach { tabLabel in
            if label == tabLabel {
                tabLabel.designed(text: tabLabel.text ?? "", font: .p14Bold)
            } else {
                tabLabel.designed(text: tabLabel.text ?? "", font: .p14Regular, textColor: .gray70)
            }
            
            tabLabel.textAlignment = .center
        }
        
        indicatorView.snp.remakeConstraints {
            $0.centerX.equalTo(label)
            $0.width.equalToSuperview().dividedBy(2.2)
            $0.bottom.equalTo(label)
            $0.height.equalTo(moderate(2))
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setLayout() {
        addChild(pageViewController)
        view.addSubviews(titleLabel,
                         searchBarStackView,
                         reviewLabel,
                         freeLabel,
                         dividerView,
                         indicatorView,
                         pageViewController.view,
                         writePostView)
        
        writePostView.addArrangedSubviews(writeImageView,
                                          writeLabel)
        
        searchBarStackView.addArrangedSubview(searchImageView)
        searchBarStackView.addArrangedSubview(searchLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(moderate(24))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        searchBarStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(19))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(42))
        }
        
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(20))
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(searchBarStackView.snp.bottom).offset(moderate(12))
            $0.width.equalToSuperview().dividedBy(2.2)
            $0.height.equalTo(moderate(40))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        freeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.size.centerY.equalTo(reviewLabel)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom)
            $0.height.equalTo(moderate(1))
            $0.leading.trailing.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerX.equalTo(reviewLabel)
            $0.width.equalTo(reviewLabel)
            $0.bottom.equalTo(reviewLabel)
            $0.height.equalTo(moderate(2))
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderate(30))
        }
        
        writePostView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalToSuperview().inset(moderate(100))
            $0.height.equalTo(moderate(42))
        }
        
        writeImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(20))
        }
    }
}

extension CommunityMainViewcontroller: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
