//
//  EditMyInfoViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/6/25.
//

import UIKit

final class EditMyInfoViewController: RootViewController {
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "내 계정", font: .p18Semi)
    }
    
    private let saveLabel = UILabel().then {
        $0.designed(text: "저장", font: .p12Regular, textColor: .gray80)
    }
    
    private let profileImageView = UIImageView(image: .profileLogo)
    
    private let photoImageView = UIImageView(image: .camera)
    
    private let nameLabel = UILabel().then {
        $0.designed(text: "닉네임", font: .p14Regular, textColor: .gray90)
    }
    
    private let nameView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
    }
    
    private let accountLabel = UILabel().then {
        $0.designed(text: "연동된 계정", font: .p14Regular, textColor: .gray90)
    }
    
    private let accountView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let accountImageView = UIImageView(image: .kakao)
    
    private let accountSNSLabel = UILabel().then {
        $0.designed(text: "유저 이메일", font: .p16Regular16)
    }
    
    private let regionLabel = UILabel().then {
        $0.designed(text: "관심 지역", font: .p14Regular, textColor: .gray90)
    }
    
    private let regionView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let regionSelectLabel = UILabel().then {
        $0.designed(text: "지역을 선택해 주세요.", font: .p16Regular16, textColor: .gray60)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    private let logoutLabel = UILabel().then {
        $0.designed(text: "로그아웃", font: .p14Regular, textColor: .gray70)
    }
    
    private let regionArrowImageView = UIImageView().then {
        $0.image = .arrowDown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(titleLabel,
                         saveLabel,
                         profileImageView,
                         nameLabel,
                         nameView,
                         accountLabel,
                         accountView,
                         regionLabel,
                         regionView,
                         dividerView,
                         logoutLabel)
        
        nameView.addSubview(nameTextField)
        
        accountView.addSubview(accountImageView)
        accountView.addSubview(accountSNSLabel)
        
        regionView.addSubview(regionSelectLabel)
        regionView.addSubview(regionArrowImageView)
        
        profileImageView.addSubview(photoImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        saveLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(29))
            $0.size.equalTo(moderate(94))
        }
        
        photoImageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(moderate(20))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        nameView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(nameLabel.snp.bottom).offset(moderate(12))
        }
        
        nameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(moderate(20))
            $0.leading.equalTo(nameView)
        }
        
        accountView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(accountLabel.snp.bottom).offset(moderate(12))
        }
        
        accountImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(12))
            $0.size.equalTo(moderate(16))
        }
        
        accountSNSLabel.snp.makeConstraints {
            $0.leading.equalTo(accountImageView.snp.trailing).offset(moderate(8))
            $0.trailing.equalToSuperview().inset(moderate(10))
            $0.centerY.equalToSuperview()
        }
        
        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(accountView)
            $0.top.equalTo(accountView.snp.bottom).offset(moderate(20))
        }
        
        regionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(regionLabel.snp.bottom).offset(moderate(12))
        }
        
        regionSelectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(12))
            $0.trailing.equalTo(regionArrowImageView.snp.leading)
        }
        
        regionArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(20))
            $0.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(1)
            $0.top.equalTo(regionView.snp.bottom).offset(moderate(30))
        }
        
        logoutLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(20))
        }
    }
}
