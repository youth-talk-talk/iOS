//
//  NewMyPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/3/25.
//

import UIKit

final class NewMyPageViewController: RootViewController {
    private let titleLabel = UILabel().then {
        $0.designed(text: "마이페이지", font: .p18Semi)
    }
    
    private let profileImageView = UIImageView(image: .profileLogo)
    
    private let nameLabel = UILabel().then {
        $0.designed(text: "유저닉네임", font: .p18Semi)
    }
    
    private let snsImageView = UIImageView(image: .kakao)
    
    private let emailLabel = UILabel().then {
        $0.designed(text: "유저 이메일", font: .p12Regular)
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
    
    private let menuScrollView = UIScrollView()
    
    private let menuStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = moderate(24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setMenuViews()
    }
    
    private func setLayout() {
        view.addSubviews(titleLabel,
                         profileImageView,
                         nameLabel,
                         snsImageView,
                         emailLabel,
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
            $0.top.equalTo(profileImageView).offset(moderate(5))
        }
        
        snsImageView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.size.equalTo(moderate(16))
            $0.bottom.equalTo(profileImageView).offset(moderate(-6))
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(snsImageView)
            $0.leading.equalTo(snsImageView.snp.trailing).offset(moderate(6))
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
            $0.bottom.equalToSuperview().inset(moderate(30))
        }
        
        menuStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
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
        [("작성한 글", UIViewController()),
         ("스크랩한 게시글", UIViewController()),
         ("좋아요한 댓글", UIViewController()),
         ("내 댓글", UIViewController())].forEach { title, moveToVC in
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
        [("약관 및 정책", UIViewController()),
         ("문의하기", UIViewController()),
         ("기타 관리", UIViewController())].forEach { title, moveToVC in
            let menuView = self.titleArrowView(text: title, onTapped: { [weak self] in
                self?.navigationController?.pushViewController(moveToVC, animated: true)
            })
            
            menuStackView.addArrangedSubview(menuView)
            
            menuView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(moderate(24))
            }
            
        }
    }
    
    private func titleArrowView(text: String, onTapped: () -> Void) -> UIView {
        let view = UIView()
        
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
