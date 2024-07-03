//
//  SignInUseCase.swift
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

final class SignInUseCase: NSObject, SignInUseCaseInterface {
    
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
    
    func loginWithApple() -> PublishRelay<Bool> {
        
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        
        return appleSignIn
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
    
    private func kakaoAppLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(with: self) { owner, oauthToken in
                print("loginWithKakaoTalk() success.")
                _ = oauthToken
                
                // 카카오 유저 정보 요청
                owner.kakaoUserInfoRequest()
                
            } onError: {owner, error  in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func kakaoAccountLoginRequest() {
        
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(with: self) { owner, oauthToken in
                print("loginWithKakaoAccount() success.")
                _ = oauthToken
                
                // 카카오 유저 정보 요창
                owner.kakaoUserInfoRequest()
            } onError: {owner, error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
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
                    
                    owner.kakaoSignIn.accept(false)
                }
                
            }.disposed(by: disposeBag)
        
    }
    
    private func requestSignInApple(credentials: ASAuthorizationAppleIDCredential) -> Single<Result<String, ASAuthorizationError>> {
        
        let userIdentifier = credentials.user
        let identityToken = tokenToString(data: credentials.identityToken)
        let authorizationCode = tokenToString(data: credentials.authorizationCode)
        
        // Single<Result<String, ASAuthorizationError>> 그대로 반환
        return Single<Result<String, ASAuthorizationError>>.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            keyChainRepository.saveAppleUserID(saveData: userIdentifier, type: .appleIdentifier)
            keyChainRepository.saveAppleUserID(saveData: identityToken, type: .appleIdentifierToken)
            keyChainRepository.saveAppleUserID(saveData: authorizationCode, type: .authorizationCode)
            
            // TODO: 서버에 애플로 가입한 회원 정보 요청 (user identifier)
            // TODO: 해당 결과에 따라 홈화면 / 약관 동의 페이지 분기 처리 한번 더 진행
            if false {
                // 로그인 처리 -> 홈화면 이동
                single(.success(.success("성공")))
            } else {
                // 회원가입 -> 약관 동의 페이지 이동
                single(.success(.failure(ASAuthorizationError(.unknown))))
            }
            
            return Disposables.create()
        }
    }
    
    private func requestSignInKakao(user: User) -> Single<Result<SignInEntity, Error>> {
        
        var identifier = getKakaoUserIdentifier(user: user)
        
        #if DEBUG
        // identifier = "67890"
        #endif
        
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
    
    private func tokenToString(data: Data?) -> String {
        
        guard let data,
              let convertedData = String(data: data, encoding: .utf8) else { return "" }
        
        return convertedData
    }
}

extension SignInUseCase {
    
    private func getKakaoUserIdentifier(user: User) -> String {
        
        guard let id = user.id else { return "" }
        
        return String(id)
    }
}

extension SignInUseCase: ASAuthorizationControllerDelegate {
    
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
}
