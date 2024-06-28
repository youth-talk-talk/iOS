//
//  SignInUseCaseInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa

protocol SignInUseCaseInterface {
    
    func loginWithApple() -> PublishRelay<Bool>
    func loginWithKakao() -> PublishRelay<Bool>
}
