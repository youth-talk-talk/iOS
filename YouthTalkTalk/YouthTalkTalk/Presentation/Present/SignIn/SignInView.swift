//
//  SignInView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import UIKit
import FlexLayout
import AuthenticationServices

final class SignInView: BaseView {
    
    let logoImageView = UIImageView()
    let appTitleLabel = UILabel()
    let appSubTitleLabel = UILabel()
    let appleSignInButton = UIButton()
    let kakaoSignInButton = UIButton()
    
    override func configureLayout() {
        
        let ratio: CGFloat = 1/3 * 100
        
        flexView.flex.justifyContent(.center).define { flex in
            
            // 상단 (여백)
            flex.addItem()
                .height(ratio%)
            
            // 중단 (로고 및 어플 명)
            flex.addItem().define { flex in
            
                flex.addItem(logoImageView)
                    .width(88)
                    .aspectRatio(1)
                    .alignSelf(.center)
                
                flex.addItem(appTitleLabel)
                    .marginTop(11)
                    .alignSelf(.center)
                
                flex.addItem(appSubTitleLabel)
                    .marginTop(7)
                    .alignSelf(.center)
            }
            .direction(.column)
            .justifyContent(.center)
            .height(ratio%)
            
            // 하단 (애플 로그인 / 카카오 로그인)
            flex.addItem().define { flex in
                
                flex.addItem(appleSignInButton)
                    .signInButton()
                    .marginBottom(10)
                
                flex.addItem(kakaoSignInButton)
                    .signInButton()
                    .marginBottom(20)
            }
            .direction(.column)
            .justifyContent(.end)
            .alignSelf(.center)
            .height(ratio%)
            .width(90%)
        }
    }

    override func configureView() {
        
        backgroundColor = .white
        logoImageView.backgroundColor = .black
        
        appTitleLabel.designed(text: "청년톡톡", fontType: .g20Bold)
        appSubTitleLabel.designed(text: "한눈에 보는 청년정책, 청년톡톡과 함께하세요!", fontType: .p14Regular)
        
        appleSignInButton.layer.masksToBounds = true
        appleSignInButton.designedByImage(.appleLogin)
        kakaoSignInButton.designedByImage(.kakaoLogin)
    }
}
