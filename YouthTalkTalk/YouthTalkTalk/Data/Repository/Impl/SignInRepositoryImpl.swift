//
//  SignInRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInRepositoryImpl: SignInRepository {
    
    private let disposeBag = DisposeBag()
    private let apiManager = APIManager()
    
    func requestAppleSignIn(userIdentifier: String, authorizationCode: String) -> Single<Result<SignInDTO, TestError>> {
        
        let bodyData = SignInBody(username: userIdentifier,
                                  authorizationCode: authorizationCode,
                                  signInType: .apple)
        let router = SignInRouter.requestAppleSignIn(signIn: bodyData)
        
        return apiManager.request(router: router, type: SignInDTO.self)
    }
    
    func requestKakaoSignIn(userIdentifier: String) -> Single<Result<SignInDTO, TestError>> {
        
        let bodyData = SignInBody(username: userIdentifier,
                                  authorizationCode: "",
                                  signInType: .kakao)
        let router = SignInRouter.requestAppleSignIn(signIn: bodyData)
        
        return apiManager.request(router: router, type: SignInDTO.self)
    }
}
