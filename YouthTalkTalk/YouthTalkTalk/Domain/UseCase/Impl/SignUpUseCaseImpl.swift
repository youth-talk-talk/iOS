//
//  SignUpUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKUser

final class SignUpUseCaseImpl: SignUpUseCase {
    
    private let disposeBag = DisposeBag()
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let signUpRepository: SignUpRepository
    
    private let appleSignUp = PublishRelay<Bool>()
    private let kakaoSignUp = PublishRelay<Bool>()
    
    init(keyChainRepository: KeyChainRepository = KeyChainRepositoryImpl(),
         userDefaultsRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl(),
         signUpRepository: SignUpRepository = SignUpRepositoryImpl()) {
        self.keyChainRepository = keyChainRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.signUpRepository = signUpRepository
    }
    
    func signUp(region: String, nickname: String) -> Observable<Result<Void, Error>> {
        
        let signUpType = userDefaultsRepository.signUpType()
        
        switch signUpType {
        case .apple:
            
            return signUpWithApple(region: region, nickname: nickname)
        case .kakao:
            
            return signUpWithKakao(region: region, nickname: nickname)
        }
    }
    
    private func signUpWithApple(region: String, nickname: String) -> Observable<Result<Void, Error>> {
        
        let identifier = KeyChainHelper().loadAppleInfo(type: .appleIdentifier) ?? ""
        let token = KeyChainHelper().loadAppleInfo(type: .appleIdentifierToken) ?? ""
        
        return signUpRepository.requestAppleSignUp(userIdentifier: identifier,
                                                   nickname: nickname,
                                                   region: region,
                                                   Token: token)
        .map { result -> Result<Void, Error> in
            switch result {
            case .success(_):
                
                return .success(())
            case .failure(let failure):
                
                return .failure(failure)
            }
        }
    }
    
    private func signUpWithKakao(region: String, nickname: String) -> Observable<Result<Void, Error>> {
        
        return UserApi.shared.rx.me()
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, user -> Observable<Result<Void, Error>> in
                
                let userIdentifier = kakaoIdentifier(user: user)
                
                return owner.signUpRepository.requestKakaoSignUp(userIdentifier: userIdentifier,
                                                                 nickname: nickname,
                                                                 region: region)
                .map { result -> Result<Void, Error> in
                    
                    switch result {
                    case .success(_):
                        
                        return .success(())
                    case .failure(let failure):
                        
                        return .failure(failure)
                    }
                }
            }
    }
}

private func kakaoIdentifier(user: User) -> String {
    
    guard let id = user.id else { return "" }
    
    return String(id)
}
