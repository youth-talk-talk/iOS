//
//  AutoSignInUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation
import AuthenticationServices
import KakaoSDKUser
import RxSwift
import RxCocoa

final class AutoSignInUseCaseImpl: AutoSignInUseCase {
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let keyChainRepository: KeyChainRepository
    private let signInRepository: SignInRepository
    
    private let disposeBag = DisposeBag()
    
    init(userDefaultsRepository: UserDefaultsRepository, keyChainRepository: KeyChainRepository, signInRepository: SignInRepository = SignInRepositoryImpl()) {
        self.userDefaultsRepository = userDefaultsRepository
        self.keyChainRepository = keyChainRepository
        self.signInRepository = signInRepository
    }
    
    func autoSignIn() -> Single<Bool> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            let signInType = userDefaultsRepository.isSignedIn()
            
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
                        single(.success(true))
                        break
                        
                    case .revoked, .notFound:
                        
                        // 로그인/회원가입 화면 이동
                        print("❗️ 애플 ID가 유효하지 않아 로그인/회원가입 화면으로 이동합니다.")
                        single(.success(false))
                        break
                        
                    default:
                        break
                    }
                }
                
            case .kakao:
                
                // 카카오 토큰 유효성 검사 진행 (Kakao SDK가 들고 있음)
                UserApi.shared.rx.me()
                    .flatMap { user in
                        let identifier = self.getKakaoUserIdentifier(user: user)
                        
                        print("❗️ 자동 로그인 - 서버로 카카오 로그인 요청을 시도합니다.")
                        return self.signInRepository.requestKakaoSignIn(userIdentifier: identifier)
                    }.subscribe(with: self) { owner, result in
                        
                        switch result {
                            
                        case .success(let signInDTO):
                            
                            print("❗️ 등록된 아이디 - \(signInDTO.data.memberId)로 홈화면으로 이동합니다.")
                            single(.success(true))
                            
                        case .failure(let error):
                            
                            print("❗️ 동록되지 않은 아이디 - 로그인/회원가입 화면으로 이동합니다.")
                            single(.success(false))
                        }
                    } onFailure: { owner, error in
                        
                        print("❗️ 유효하지 않은 토큰 - 로그인/회원가입 화면으로 이동합니다.")
                        single(.success(false))
                    }
                    .disposed(by: disposeBag)
                
                break
                
            case .none:
                
                // 로그인/회원가입 화면 이동
                print("❗️ 로그인 이력이 없습니다. 로그인/회원가입 화면으로 이동합니다.")
                single(.success(false))
            }
            
            return Disposables.create()
        }
    }
}

extension AutoSignInUseCaseImpl {
    
    private func getKakaoUserIdentifier(user: User) -> String {
        
        guard let id = user.id else { return "" }
        
        return String(id)
    }
}
