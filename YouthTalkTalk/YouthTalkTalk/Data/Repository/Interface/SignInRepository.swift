//
//  SignInRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation
import RxSwift

protocol SignInRepository {
    
    func requestAppleSignIn(userIdentifier: String, authorizationCode: String) -> Single<Result<SignInDTO, TestError>>
    func requestKakaoSignIn(userIdentifier: String) -> Single<Result<SignInDTO, TestError>>
}
