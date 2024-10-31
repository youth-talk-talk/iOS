//
//  SignUpRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/11/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SignUpRepositoryImpl: SignUpRepository {

    private let disposeBag = DisposeBag()
    private let apiManager = APIManager()

    func requestAppleSignUp(
        userIdentifier: String, nickname: String, region: String, Token: String
    ) -> Observable<Result<SignUpDTO, APIError>> {

        let bodyData = SignUpBody(
            socialType: .apple,
            socialId: userIdentifier,
            nickname: nickname,
            region: region,
            idToken: Token)
        let router = SignUpRouter.requestAppleSignUp(signUp: bodyData)

        return apiManager.request(router: router, type: SignUpDTO.self)
            .asObservable()
    }

    func requestKakaoSignUp(
        userIdentifier: String, nickname: String, region: String
    ) -> Observable<Result<SignUpDTO, APIError>> {

        let bodyData = SignUpBody(
            socialType: .kakao,
            socialId: userIdentifier,
            nickname: nickname,
            region: region,
            idToken: "")
        let router = SignUpRouter.requestKakaoSignUp(signUp: bodyData)

        return apiManager.request(router: router, type: SignUpDTO.self)
            .asObservable()
    }
}
