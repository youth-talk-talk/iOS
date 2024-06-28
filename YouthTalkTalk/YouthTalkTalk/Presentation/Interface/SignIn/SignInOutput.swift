//
//  SignInOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import RxCocoa
import AuthenticationServices

protocol SignInOutput {
    
    var signInSuccessApple: Driver<Bool> { get }
    var signInSuccessKakao: Driver<Bool> { get }
}
