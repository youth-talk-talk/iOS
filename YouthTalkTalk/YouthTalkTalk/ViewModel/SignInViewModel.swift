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

final class SignInViewModel: NSObject, ViewModelInterface {
    
    var input: Input = Input()
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        
        let appleSignInButtonClicked = PublishRelay<Void>()
        let appleSignInCompleted = PublishRelay<Void>()
    }
    
    struct Output {
        
        let signInForApple: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let appleSignIn = PublishRelay<Void>()
        
        // apple 로그인 이벤트 처리
        input.appleSignInButtonClicked
            .subscribe(with: self) { owner, _ in
                
                let appleProvider = ASAuthorizationAppleIDProvider()
                let request = appleProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.performRequests()
                
            }.disposed(by: disposeBag)
        
        input.appleSignInCompleted
            .subscribe(with: self) { owner, _ in
                appleSignIn.accept(())
            }.disposed(by: disposeBag)
        
        return Output(signInForApple: appleSignIn.asDriver(onErrorJustReturn: ()))
    }
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userIdentifier = appleIDCredential.user
        
        // 1. userIdentifier로 서버 통신
        // 2-1. 최초 회원가입 유저
            // 약관 동의 화면으로 이동
        // 2-2. 애플 회원가입만 한 유저
            // 약관 동의 화면으로 이동
        // 2-3. 애플 로그인 유저
            // 홈 뷰로 전환
        
        input.appleSignInCompleted.accept(())
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        
        // 에러
        print("error / 취소")
    }
}
