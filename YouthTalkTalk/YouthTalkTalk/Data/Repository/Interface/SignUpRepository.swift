//
//  SignUpRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/11/24.
//

import Foundation
import RxSwift

protocol SignUpRepository {
    
    func requestAppleSignUp(userIdentifier: String, nickname: String, region: String, Token: String) -> Observable<Result<SignUpDTO, APIError>>
    func requestKakaoSignUp(userIdentifier: String, nickname: String, region: String) -> Observable<Result<SignUpDTO, APIError>>
}
