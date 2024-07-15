//
//  SignInRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation
import RxSwift

protocol SignInRepository {
    
    func requestAppleSignIn(userIdentifier: String, authorizationCode: String, identityToken: String) -> Single<Result<SignInDTO, APIError>>
    func requestKakaoSignIn(userIdentifier: String) -> Single<Result<SignInDTO, APIError>>
}
