//
//  SettingViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class SettingViewController: RootViewController {
    
    let nicknameLabel = UILabel()
    let nicknameButtonView = TitleWithImageButtonView()
    
    let regionLabel = UILabel()
    let regionButtonView = TitleWithImageButtonView()
    
    let logoutLabel = UILabel()
    let withdrawLabel = UILabel()
    
    private let data: MeEntity
    
    init(data: MeEntity) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        
        view.backgroundColor = .white
        
        nicknameLabel.designed(text: "닉네임 설정", fontType: .g14Bold)
        nicknameButtonView.setTitle(data.nickname)
        nicknameButtonView.setImage(.edit)
        
        regionLabel.designed(text: "나의 지역설정", fontType: .g14Bold)
        regionButtonView.setTitle(data.region)
        regionButtonView.setImage(.setting)
        
        logoutLabel.designed(text: "로그아웃", fontType: .p16SemiBold, textColor: .gray60)
        withdrawLabel.designed(text: "회원탈퇴", fontType: .p16SemiBold, textColor: .gray60)
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(nicknameLabel)
                .marginTop(29)
                .width(100%)
            
            flex.addItem(nicknameButtonView)
                .marginTop(12)
                .width(100%)
                .height(50)
            
            flex.addItem(regionLabel)
                .marginTop(29)
                .width(100%)
            
            flex.addItem(regionButtonView)
                .marginTop(12)
                .width(100%)
                .height(50)
            
            flex.addItem(logoutLabel)
                .marginTop(24)
                .width(100%)
                .height(50)
            
            flex.addItem(withdrawLabel)
                .width(100%)
                .height(50)
            
        }
        .marginHorizontal(17)
    }
    
    override func bind() {
        
        regionButtonView.imageButton.rx.tap
            .bind(with: self) { owner, _ in
                //
            }
            .disposed(by: disposeBag)
    }
}
