//
//  MyPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/3/25.
//

import UIKit
import Kingfisher

final class MyPageViewController: RootViewController {
    
    private var myInfo: MeDTO?
    
    private let viewModel = MyPageViewModel()
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "마이페이지", font: .p18Semi)
    }
    
    private let profileImageView = UIImageView(image: .profileLogo).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = moderate(30)
    }
    
    private let nameLabel = UILabel().then {
        $0.designed(font: .p18Semi)
    }
    
    private let rightArrowImageView = UIImageView(image: .chevronRight.withTintColor(.gray100))
    
    private let verticalDividerView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    private let scrapView = UIView()
    private let scrapImageView = UIImageView(image: .bookmark)
    private let scrapLabel = UILabel().then {
        $0.designed(text: "스크랩한 정책", font: .p14Regular)
    }
    
    private let notiView = UIView()
    private let notiImageView = UIImageView(image: .noti)
    private let notiLabel = UILabel().then {
        $0.designed(text: "알림함", font: .p14Regular)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let dividerView2 = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let menuScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset.bottom = moderate(30)
    }
    
    private let menuStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = moderate(24)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightArrowImageView.onTapped { [weak self] in
            guard let myInfo = self?.myInfo else { return }
            let vc = EditMyInfoViewController(myInfo, self!.viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        scrapView.onTapped { [weak self] in
            let vc = MyScrapViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        setLayout()
        setMenuViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getMyInfo { [weak self] myInfo in
            DispatchQueue.main.async {
                if let url = URL(string: myInfo.data.profileImgUrl ?? "") {
                    self?.profileImageView.kf.setImage(with: url)
                }
                self?.nameLabel.text = myInfo.data.nickname
                self?.myInfo = myInfo
            }
        }
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setLayout() {
        view.addSubviews(titleLabel,
                         profileImageView,
                         nameLabel,
                         rightArrowImageView,
                         scrapView,
                         notiView,
                         dividerView,
                         menuScrollView,
                         verticalDividerView)
        
        menuScrollView.addSubview(menuStackView)
        
        scrapView.addSubview(scrapImageView)
        scrapView.addSubview(scrapLabel)
        
        notiView.addSubview(notiImageView)
        notiView.addSubview(notiLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(32))
            $0.size.equalTo(moderate(60))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(moderate(10))
            $0.centerY.equalTo(profileImageView)
        }
        
        rightArrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.centerY.equalTo(profileImageView)
            $0.size.equalTo(24)
        }
        
        scrapView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.4)
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderate(28))
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(50))
        }
        
        scrapImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderate(24))
            $0.top.equalToSuperview()
        }
        
        scrapLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        notiView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2.4)
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderate(28))
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(50))
        }
        
        notiImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderate(24))
            $0.top.equalToSuperview()
        }
        
        notiLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        verticalDividerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrapView)
            $0.height.equalTo(moderate(52))
            $0.width.equalTo(moderate(1))
        }
        
        menuScrollView.snp.makeConstraints {
            $0.top.equalTo(scrapView.snp.bottom).offset(moderate(24))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        menuStackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
    
    private func setMenuViews() {
        let dividerView = UIView().then {
            $0.backgroundColor = .gray40
        }
        
        let communityLabel = UILabel().then {
            $0.designed(text: "커뮤니티 활동", font: .p16SemiBold)
        }
        
        menuStackView.addArrangedSubviews(dividerView,
                                          communityLabel)
        menuStackView.setCustomSpacing(moderate(20), after: communityLabel)
        
        communityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        dividerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(moderate(10))
            $0.leading.equalToSuperview()
        }
        
        // 커뮤니티 메뉴
        [("작성한 글", MyOrScrapPostViewController(type: .myPost)),
         ("스크랩한 게시글", MyOrScrapPostViewController(type: .scrapPost)),
         ("좋아요한 댓글", MyOrLikedCommentViewController(type: .likedComment)),
         ("내 댓글", MyOrLikedCommentViewController(type: .myComment))].forEach { title, moveToVC in
            
            let menuView = self.titleArrowView(text: title, onTapped: { [weak self] in
                self?.navigationController?.pushViewController(moveToVC, animated: true)
            })
            
            menuStackView.addArrangedSubview(menuView)
            
            menuView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(moderate(24))
            }
        }
        
        let dividerView2 = UIView().then {
            $0.backgroundColor = .gray40
        }
        
        let manageLabel = UILabel().then {
            $0.designed(text: "관리", font: .p16SemiBold)
        }
        
        menuStackView.addArrangedSubviews(dividerView2,
                                          manageLabel)
        
        dividerView2.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(moderate(10))
            $0.leading.equalToSuperview()
        }
        
        manageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        menuStackView.setCustomSpacing(moderate(20), after: dividerView)
        menuStackView.setCustomSpacing(moderate(20), after: manageLabel)
        
        // 관리 메뉴
        [("약관 및 정책", SettingTermViewController()),
         ("문의하기", UIViewController()),
         ("기타 관리", SettingViewController())].forEach { title, moveToVC in
            let menuView = self.titleArrowView(text: title, onTapped: { [weak self] in
                if title == "문의하기" {
                    if let url = URL(string: "https://forms.gle/GuK3MUu6Hqzfv5mR9") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    self?.navigationController?.pushViewController(moveToVC, animated: true)
                }
            })
            
            menuStackView.addArrangedSubview(menuView)
            
            menuView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(moderate(24))
            }
        }
    }
    
    private func titleArrowView(text: String, onTapped: @escaping () -> Void) -> UIView {
        let view = UIView()
        
        view.onTapped { onTapped() }
        
        let titleLabel = UILabel().then {
            $0.designed(text: text, font: .p16Regular16, textColor: .gray90)
        }
        
        let arrowImageView = UIImageView(image: .chevronRight.withTintColor(.gray100))
        
        view.addSubviews(titleLabel, arrowImageView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(24))
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        return view
    }
}
