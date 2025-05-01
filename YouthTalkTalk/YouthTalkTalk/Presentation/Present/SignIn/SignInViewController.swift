//
//  SignInViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import UIKit

import Lottie
import RxSwift

final class SignInViewController: RootViewController{
    
    var viewModel: SignInInterface
    
    private let logoAnimationView: LottieAnimationView = .init(name: "splash",
                                                                bundle: Bundle.main).then {
        $0.loopMode = .loop
        $0.play()
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "청년톡톡", font: .p24Bold)
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(text: "한눈에 보는 청년 정책! 청년톡톡과 함께해요 :)", font: .p16Regular16)
    }
    
    private let kakaoButton = UIButton().then {
        $0.designWithImage(title: "카카오로 시작하기",
                           image: .kakao,
                           bgColor: .kakao,
                           titleColor: .black,
                           fontType: .p16Regular16)
    }
    
    private let appleButton = UIButton().then {
        $0.designWithImage(title: "Apple로 시작하기",
                           image: .apple,
                           bgColor: .apple,
                           titleColor: .white,
                           fontType: .p16Regular16)
    }
    
    init(viewModel: SignInInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kakaoButton.onTapped { [weak self] in
            self?.viewModel.input.kakaoSignInButtonClicked.accept(())
        }
        
        appleButton.onTapped { [weak self] in
            self?.viewModel.input.appleSignInButtonClicked.accept(())
        }
//        
//        viewModel.output.signInSuccessKakao
//            .drive { [weak self] isSuccess in
//                self?.moveToPage(isLoginSuccess: isSuccess)
//            }
//            .disposed(by: disposeBag)
//                
//        viewModel.output.signInSuccessApple
//            .drive { [weak self] isSuccess in
//                self?.moveToPage(isLoginSuccess: isSuccess)
//            }
//            .disposed(by: disposeBag)
//        
        view.addSubview(logoAnimationView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(kakaoButton)
        view.addSubview(appleButton)
        
        logoAnimationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(411)
            $0.height.equalTo(393)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoAnimationView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(40)
            $0.height.equalTo(45)
            $0.width.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(14)
            $0.height.equalTo(45)
            $0.width.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func moveToPage(isLoginSuccess: Bool) {
        if isLoginSuccess { // 로그인 성공 시 메인페이지 이동
            SceneDelegate.makeRootVC()
            
        } else { // 로그인 실패 시 회원가입 이동
            
        }
    }
}
