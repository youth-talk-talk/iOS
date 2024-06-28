//
//  AutoSignInUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKUser
import RxSwift
import RxCocoa

final class AutoSignInUseCase: AutoSignInUseCaseInterface {
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let keyChainRepository: KeyChainRepository
    
    private let disposeBag = DisposeBag()
    
    init(userDefaultsRepository: UserDefaultsRepository, keyChainRepository: KeyChainRepository) {
        self.userDefaultsRepository = userDefaultsRepository
        self.keyChainRepository = keyChainRepository
    }
    
    func autoSignIn() -> PublishRelay<Bool> {
        
        let signInType = userDefaultsRepository.isSignedIn()
        
        // var isSuccess: Bool = false
        
        var isSuccess = PublishRelay<Bool>()
        
        switch signInType {
        case .apple:
            
            let appleUserIdentifier = keyChainRepository.loadAppleUserID(type: .appleIdentifier)
            
            // 애플 토큰 유효성 검사 진행 (User ID 필요)
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleUserIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    
                    // 서버로 애플 로그인 요청 -> 홈화면 이동
                    print("❗️ 애플 ID가 유효하여 서버로 애플 로그인 요청을 시도합니다.")
                    
                    isSuccess.accept(true)
                    break
                    
                case .revoked, .notFound:
                    
                    // 로그인/회원가입 화면 이동
                    print("❗️ 애플 ID가 유효하지 않아 로그인/회원가입 화면으로 이동합니다.")
                    isSuccess.accept(false)
                    break
                    
                default:
                    break
                }
            }
            
        case .kakao:
            
            // 카카오 토큰 유효성 검사 진행 (Kakao SDK가 들고 있음)
            UserApi.shared.rx.me()
                .subscribe (onSuccess:{ user in
                    
                    // 서버로 카카오 로그인 요청 -> 홈화면 이동
                    print("❗️ 카카오 토큰이 유효하여 서버로 카카오 로그인 요청을 시도합니다.")
                    let userID = user.id
                    
                    isSuccess.accept(true)
                    
                }, onFailure: {error in
                    
                    // 로그인/회원가입 화면 이동
                    print("❗️ 카카오 토큰이 유효하지 않아 로그인/회원가입 화면으로 이동합니다.")
                    
                    isSuccess.accept(false)
                    
                })
                .disposed(by: disposeBag)
            
        case .none:
            
            // 로그인/회원가입 화면 이동
            print("❗️ 로그인 이력이 없습니다. 로그인/회원가입 화면으로 이동합니다.")
            isSuccess.accept(false)
            
            break
        }
        
        return isSuccess
    }
}
