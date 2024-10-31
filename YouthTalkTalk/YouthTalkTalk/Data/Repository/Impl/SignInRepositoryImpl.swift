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
    
    func requestAppleSignIn(userIdentifier: String, authorizationCode: String, identityToken: String) -> Single<Result<SignInDTO, APIError>> {
        
        let bodyData = SignInBody(socialType: .apple,
                                  socialId: userIdentifier,
                                  authorizationCode: authorizationCode,
                                  identityToken: identityToken)
        
        let router = SignInRouter.requestAppleSignIn(signIn: bodyData)
        
        return apiManager.request(router: router, type: SignInDTO.self)
    }
    
    func requestKakaoSignIn(userIdentifier: String) -> Single<Result<SignInDTO, APIError>> {
        
        let bodyData = SignInBody(socialType: .kakao,
                                  socialId: userIdentifier,
                                  authorizationCode: "",
                                  identityToken: "")
        
        let router = SignInRouter.requestKakaoSignIn(signIn: bodyData)
        
        return apiManager.request(router: router, type: SignInDTO.self)
    }
}
