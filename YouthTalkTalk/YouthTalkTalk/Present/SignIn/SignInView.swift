//
//  SignInView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import UIKit
import FlexLayout

class SignInView: BaseView {
    
    let logoImageView = UIImageView()
    let appTitleLabel = UILabel()
    let appSubTitleLabel = UILabel()
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            // 상단 (여백)
            flex.addItem().grow(1)
            
            // 중단 (로고 및 어플 명)
            flex.addItem().direction(.column).alignItems(.center).define { flex in
            
                flex.addItem(logoImageView)
                    .width(88)
                    .aspectRatio(1)
                
                flex.addItem(appTitleLabel)
                    .marginTop(11)
                
                flex.addItem(appSubTitleLabel)
                    .marginTop(7)
            }
            
            // 하단 (애플 로그인 / 카카오 로그인)
            flex.addItem().grow(1).define { flex in
                
                flex.addItem().grow(1)
                
                flex.addItem(appleLoginButton)
                    .signInButton()
                    .marginBottom(10)
                    .backgroundColor(.red)
                
                flex.addItem(kakaoLoginButton)
                    .signInButton()
                    .marginBottom(20)
                    .backgroundColor(.red)
            }
        }
    }

    override func configureView() {
        
        backgroundColor = .white
        logoImageView.backgroundColor = .black
        
        appTitleLabel.designed(text: "청년톡톡", fontType: .titleForAppBold)
        appSubTitleLabel.designed(text: "한눈에 보는 청년정책, 청년톡톡과 함께하세요!", fontType: .bodyRegular)
    }
}
