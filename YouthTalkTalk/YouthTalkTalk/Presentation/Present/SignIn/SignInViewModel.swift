//
//  SignInViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/13/24.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa
// import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

final class SignInViewModel: NSObject, SignInInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var appleSignInUseCase: AppleSignInUseCaseInterface
    
    var input: SignInInput { return self }
    var output: SignInOutput { return self }
    
    // Inputs
    let appleSignInButtonClicked = PublishRelay<Void>()
    let kakaoSignInButtonClicked = PublishRelay<Void>()
    
    // Ouputs
    var signInSuccessApple: Driver<String>
    var signInFailureApple: Driver<ASAuthorizationError>
    
    // APPLE LOGIN
    private let signInSuccessAppleRelay = PublishRelay<String>()
    private let signInFailureAppleRelay = PublishRelay<ASAuthorizationError>()
    
    init(appleSignInUseCase: AppleSignInUseCaseInterface) {
        
        signInSuccessApple = signInSuccessAppleRelay.asDriver(onErrorJustReturn: "성공")
        signInFailureApple = signInFailureAppleRelay.asDriver(onErrorJustReturn: .init(.unknown))
        
        self.appleSignInUseCase = appleSignInUseCase
        
        super.init()
        
        // 애플 로그인 버튼 클릭
        appleSignInButtonClicked
            .bind(with: self) { owner, _ in
                
                owner.requestSignInApple()
            }.disposed(by: disposeBag)
        
        // 카카오 로그인 버튼 클릭
        kakaoSignInButtonClicked
            .bind(with: self) { owner, _ in
                
                // 카카오 앱 설치 여부 확인
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    print("✏️설치 확인")
                    // 카카오 앱으로 로그인 요청
                    owner.kakaoAppLoginRequest()
                    
                } else {
                    
                    // 카카오 계정으로 로그인 요청
                    owner.kakaoAccountLoginRequest()
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func requestSignInApple() {
        
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    private func kakaoAppLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(with: self) { owner, oauthToken in
                print("loginWithKakaoTalk() success.")
                _ = oauthToken
                
                // 카카오 유저 정보 요청
                owner.kakaoUserInfoRequest()
                
            } onError: {owner, error  in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func kakaoAccountLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(with: self) { owner, oauthToken in
                print("loginWithKakaoAccount() success.")

                _ = oauthToken
            } onError: {owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func kakaoUserInfoRequest() {
        
        UserApi.shared.rx.me()
            .subscribe (onSuccess:{ user in
                print("me() success.")
                
                dump(user)
                _ = user
            }, onFailure: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        // 1. userIdentifier로 서버 통신
        // 2-1. 최초 회원가입 유저
        // 약관 동의 화면으로 이동
        // 2-2. 애플 회원가입만 한 유저
        // 약관 동의 화면으로 이동
        // 2-3. 애플 로그인 유저
        // 홈 뷰로 전환
        
        appleSignInUseCase.loginWithApple(credentials: appleIDCredential)
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let userData):
                    owner.signInSuccessAppleRelay.accept(userData)
                    
                case .failure(let error):
                    owner.signInFailureAppleRelay.accept(error)
                }
            }.disposed(by: disposeBag)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        
        // 에러
        print("error / 취소")
    }
}
