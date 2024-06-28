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
    
    private var autoSignInUseCase: AutoSignInUseCaseInterface
    private let disposeBag = DisposeBag()
    
    var input: SplashInput { return self }
    var output: SplashOutput { return self }
    
    //inputs
    var checkSignedIn = PublishRelay<Void>()
    
    //outputs
    var isAutoSignIn: Driver<Bool>
    
    init(autoSignInUseCase: AutoSignInUseCaseInterface) {
        
        self.autoSignInUseCase = autoSignInUseCase
        
        let autoSignIn = PublishRelay<Bool>()
        isAutoSignIn = autoSignIn.asDriver(onErrorJustReturn: false)
        
        checkSignedIn
            .flatMap { _ in
            return autoSignInUseCase.autoSignIn()
        }.subscribe(with: self) { owner, isSuccess in
            autoSignIn.accept(isSuccess)
        }.disposed(by: disposeBag)
    }
}
