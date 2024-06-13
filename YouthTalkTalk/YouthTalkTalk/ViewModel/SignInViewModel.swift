//
//  SignInViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelInterface {
    
    var input: Input = Input()
    
    private(set) var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        
        let appleSignIn = PublishRelay<Void>()
    }
    
    struct Output {
        
        let signInForApple: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
     
        let appleSignIn = PublishRelay<Void>()
        
        // apple 로그인 이벤트 처리
        input.appleSignIn
            .subscribe(with: self) { owner, _ in
                
                appleSignIn.accept(())
            }.disposed(by: disposeBag)
        
        return Output(signInForApple: appleSignIn.asDriver(onErrorJustReturn: ()))
    }
}
