//
//  SplashViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SplashViewModel: SplashInterface {
    
    private var signInUseCase: SignInUseCase
    private let disposeBag = DisposeBag()
    
    var input: SplashInput { return self }
    var output: SplashOutput { return self }
    
    //inputs
    var checkSignedIn = PublishRelay<Void>()
    
    //outputs
    var isAutoSignIn: Driver<Bool>
    
    init(signInUseCase: SignInUseCase) {
        
        self.signInUseCase = signInUseCase
        
        let autoSignIn = PublishRelay<Bool>()
        isAutoSignIn = autoSignIn.asDriver(onErrorJustReturn: false)
        
        checkSignedIn
            // .flatMap { _ in
            //     return signInUseCase.loginWithAuto()
            // }
        .subscribe(with: self) { owner, _ in
            autoSignIn.accept(true)
        }.disposed(by: disposeBag)
    }
}
