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
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var appleSignInUseCase: AppleSignInUseCaseInterface
    
    var input: SignInInput { return self }
    var output: SignInOutput { return self }
    
    // Inputs
    let appleSignInButtonClicked = PublishRelay<Void>()
    
    // Ouputs
    var signInSuccessApple: Driver<String>
    var signInFailureApple: Driver<ASAuthorizationError>
    
    private let signInSuccessAppleRelay = PublishRelay<String>()
    private let signInFailureAppleRelay = PublishRelay<ASAuthorizationError>()
    
    init(appleSignInUseCase: AppleSignInUseCaseInterface) {
        
        signInSuccessApple = signInSuccessAppleRelay.asDriver(onErrorJustReturn: "성공")
        signInFailureApple = signInFailureAppleRelay.asDriver(onErrorJustReturn: .init(.unknown))
        
        self.appleSignInUseCase = appleSignInUseCase
        
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
