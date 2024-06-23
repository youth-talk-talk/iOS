//
//  AppleSignInImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import AuthenticationServices
import RxSwift

final class AppleSignInImpl: AppleSignInUseCase {
    
    func loginWithApple(credentials: ASAuthorizationAppleIDCredential) -> Single<Result<String, ASAuthorizationError>> {
        
        let userIdentifier = credentials.user
        
        // userIdentifier로 서버 통신 진행
        
        // Single<Result<String, ASAuthorizationError>> 그대로 반환
        
        // 우선은 커스텀하게 내보내기
        return Single<Result<String, ASAuthorizationError>>.create { single in
            
            // 성공
            single(.success(.success("성공")))
            
            // 실패
            single(.success(.failure(ASAuthorizationError(.unknown))))
            
            
            return Disposables.create()
        }
    }
}
