//
//  SignInUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

final class SignInUseCaseImpl: NSObject, SignInUseCase {
    
    private let disposeBag = DisposeBag()
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let signInRepository: SignInRepository
    
    private let appleSignIn = PublishRelay<Bool>()
    private let kakaoSignIn = PublishRelay<Bool>()
    
    init(keyChainRepository: KeyChainRepository, userDefaultsRepository: UserDefaultsRepository, signInRepository: SignInRepository = SignInRepositoryImpl() ) {
        self.keyChainRepository = keyChainRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.signInRepository = signInRepository
    }
    
    func loginWithKakao() -> PublishRelay<Bool> {
        
        // 카카오 앱 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 앱으로 로그인 요청
            kakaoAppLoginRequest()
        } else {
            // 카카오 계정으로 로그인 요청
            kakaoAccountLoginRequest()
        }
        
        return kakaoSignIn
    }
    
    private func tokenToString(data: Data?) -> String {
        
        guard let data,
              let convertedData = String(data: data, encoding: .utf8) else { return "" }
        
        return convertedData
    }
}

extension SignInUseCaseImpl {
    
    // 카카오 SDK 로그인 요청 - 앱으로 시도
    private func kakaoAppLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(with: self) { owner, oauthToken in
                
                print("loginWithKakaoTalk() success.")
                // 카카오 유저 정보 요청
                owner.kakaoUserInfoRequest()
                
            } onError: {owner, error  in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    // 카카오 SDK 로그인 요청 - 웹으로 시도
    private func kakaoAccountLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(with: self) { owner, oauthToken in
                
                print("loginWithKakaoAccount() success.")
                // 카카오 유저 정보 요창
                owner.kakaoUserInfoRequest()
            } onError: {owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    // 서버 로그인 요청 (카카오)
    private func requestSignInKakao(user: User) -> Single<Result<SignInEntity, Error>> {
        
        var identifier = getKakaoUserIdentifier(user: user)
        
        return signInRepository.requestKakaoSignIn(userIdentifier: identifier)
            .map { result in
                
                switch result {
                    
                case .success(let signInDTO):
                    let signInEntity = Mapper.mapSingIn(dto: signInDTO)
                    
                    return .success(signInEntity)
                    
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    // 카카오 SDK 유저 정보 요청
    private func kakaoUserInfoRequest() {
        
        UserApi.shared.rx.me()
            .flatMap { user in
                return self.requestSignInKakao(user: user)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let signInEntity):
                    
                    owner.userDefaultsRepository.saveSignedInState(signedInType: .kakao)
                    owner.kakaoSignIn.accept(true)
                    
                case .failure(let error):
                    
                    owner.userDefaultsRepository.saveSignUpType(signUpType: .kakao)
                    owner.kakaoSignIn.accept(false)
                }
                
            }.disposed(by: disposeBag)
        
    }
}

// MARK: 카카오 관련 로직
extension SignInUseCaseImpl {
    
    private func getKakaoUserIdentifier(user: User) -> String {
        
        guard let id = user.id else { return "" }
        
        return String(id)
    }
}

// MARK: 애플 관련 로직
extension SignInUseCaseImpl: ASAuthorizationControllerDelegate {
    
    // 애플로 로그인 요청 설정 및 요청
    func loginWithApple() -> PublishRelay<Bool> {
        
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        
        return appleSignIn
    }
    
    // 애플에게 정보 받기
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        requestSignInApple(credentials: appleIDCredential)
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let userData):
                    
                    // 로그인 처리 -> 홈화면 이동
                    owner.userDefaultsRepository.saveSignedInState(signedInType: .apple)
                    owner.appleSignIn.accept(true)
                    
                    break
                    
                case .failure(let error):
                    
                    // 회원가입 -> 약관 동의 페이지 이동
                    owner.userDefaultsRepository.saveSignUpType(signUpType: .apple)
                    owner.appleSignIn.accept(false)
                    
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        
        // 에러
        print("error / 취소")
    }
    
    private func requestSignInApple(credentials: ASAuthorizationAppleIDCredential) -> Single<Result<SignInEntity, Error>> {
        
        let userIdentifier = credentials.user
        let identityToken = tokenToString(data: credentials.identityToken)
        let authorizationCode = tokenToString(data: credentials.authorizationCode)
        
        // MARK: 키체인 / 유저 Identifier / 유저 토큰 / 인증 코드 저장
        keyChainRepository.saveAppleUserID(saveData: userIdentifier, type: .appleIdentifier)
        keyChainRepository.saveAppleUserID(saveData: identityToken, type: .appleIdentifierToken)
        keyChainRepository.saveAppleUserID(saveData: authorizationCode, type: .authorizationCode)
        
        return signInRepository.requestAppleSignIn(userIdentifier: userIdentifier,
                                                   authorizationCode: authorizationCode,
                                                   identityToken: identityToken)
        .map { result in
            
            switch result {
                
            case .success(let signInDTO):
                let signInEntity = Mapper.mapSingIn(dto: signInDTO)
                
                return .success(signInEntity)
                
            case .failure(let error):
                
                return .failure(error)
            }
        }
    }
}

// MARK: 자동 로그인 부분
extension SignInUseCaseImpl {
    
    func loginWithAuto() -> PublishRelay<Bool> {
        
        let signInType = userDefaultsRepository.isSignedIn()
        
        switch signInType {
        case .apple:
            
            return loginWithApple()
        case .kakao:
            
            return loginWithKakao()
        case .none:
            
            return PublishRelay<Bool>()
        }
    }
}
