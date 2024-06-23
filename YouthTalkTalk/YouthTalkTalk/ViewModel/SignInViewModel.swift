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

final class SignInViewModel: NSObject, SignInInterface {
    
    var input: SignInInput { return self }
    var output: SignInOutput { return self }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // Inputs
    let appleSignInButtonClicked = PublishRelay<Void>()
    let appleSignInCompleted = PublishRelay<Void>()
    
    // Ouputs
    var signInForApple: Driver<Void>
    
    override init() {
        
        signInForApple = appleSignInCompleted.asDriver(onErrorJustReturn: ())
        
        super.init()
        
        appleSignInButtonClicked
            .bind(with: self) { owner, _ in
                
                owner.requestSignInApple()
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
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userIdentifier = appleIDCredential.user
        print(userIdentifier)
        
        // 1. userIdentifier로 서버 통신
        // 2-1. 최초 회원가입 유저
        // 약관 동의 화면으로 이동
        // 2-2. 애플 회원가입만 한 유저
        // 약관 동의 화면으로 이동
        // 2-3. 애플 로그인 유저
        // 홈 뷰로 전환
        
        appleSignInCompleted.accept(())
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        
        // 에러
        print("error / 취소")
    }
}
