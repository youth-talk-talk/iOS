//
//  AppleSignInUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import AuthenticationServices
import RxSwift

final class AppleSignInUseCase: AppleSignInUseCaseInterface {
    
    private let keyChainRepository: KeyChainRepository
    
    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }
    
    func loginWithApple(credentials: ASAuthorizationAppleIDCredential) -> Single<Result<String, ASAuthorizationError>> {
        
        let userIdentifier = credentials.user
        let identityToken = credentials.identityToken?.base64EncodedString()
        let authorizationCode = credentials.authorizationCode?.base64EncodedString()
        
        // Single<Result<String, ASAuthorizationError>> 그대로 반환
        return Single<Result<String, ASAuthorizationError>>.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            keyChainRepository.saveAppleUserID(saveData: userIdentifier, type: .appleIdentifier)
            keyChainRepository.saveAppleUserID(saveData: identityToken, type: .appleIdentifierToken)
            keyChainRepository.saveAppleUserID(saveData: authorizationCode, type: .authorizationCode)
            
            // userIdentifier로 서버 통신 진행
            // API 통신 결과 Result<T, error>
            if true {
                // 로그인 처리 -> 홈화면 이동
                single(.success(.success("성공")))
            } else {
                // 회원가입 -> 약관 동의 페이지 이동
                single(.success(.failure(ASAuthorizationError(.unknown))))
            }
            
            return Disposables.create()
        }
    }
}
