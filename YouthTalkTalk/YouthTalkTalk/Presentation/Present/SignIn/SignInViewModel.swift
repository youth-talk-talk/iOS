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

final class SignInViewModel: SignInInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var signInUseCase: SignInUseCase
    
    var input: SignInInput { return self }
    var output: SignInOutput { return self }
    
    // Inputs
    let appleSignInButtonClicked = PublishRelay<Void>()
    let kakaoSignInButtonClicked = PublishRelay<Void>()
    
    // Ouputs
    var signInSuccessApple: Driver<Bool>
    var signInSuccessKakao: Driver<Bool>
    
    // APPLE LOGIN
    private let signInSuccessAppleRelay = PublishRelay<Bool>()
    private let signInSuccessKakaoRelay = PublishRelay<Bool>()
    
    init(signInUseCase: SignInUseCase) {
        
        signInSuccessApple = signInSuccessAppleRelay.asDriver(onErrorJustReturn: false)
        signInSuccessKakao = signInSuccessKakaoRelay.asDriver(onErrorJustReturn: false)
        
        self.signInUseCase = signInUseCase
        
        // 애플 로그인 버튼 클릭
        appleSignInButtonClicked
            .flatMap { _ in
                return signInUseCase.loginWithApple()
            }.subscribe(with: self) { owner, isSuccess in
                
                owner.signInSuccessAppleRelay.accept(isSuccess)
                
            }.disposed(by: disposeBag)
        
        // 카카오 로그인 버튼 클릭
        kakaoSignInButtonClicked
            .flatMap { _ in
                return signInUseCase.loginWithKakao()
            }.subscribe(with: self) { owner, isSuccess in
                
                owner.signInSuccessKakaoRelay.accept(isSuccess)
                
            }.disposed(by: disposeBag)
    }
}
