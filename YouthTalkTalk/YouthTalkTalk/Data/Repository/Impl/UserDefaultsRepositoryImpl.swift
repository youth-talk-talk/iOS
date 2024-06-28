//
//  UserDefaultsRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation

final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: SIGN IN STATE
    func saveSignedInState(signedInType: SignInType) {
        print("❗️ 마지막 로그인 기록을 \(signedInType.rawValue)로 저장합니다.")
        userDefaults.isSignIn = signedInType
    }
    
    func isSignedIn() -> SignInType {
        print("❗️ 마지막 로그인 기록은 \(userDefaults.isSignIn.rawValue)입니다.")
        return userDefaults.isSignIn
    }
    
    // MARK: SIGN UP TYPE
    func saveSignUpType(signUpType: SignUpType) {
        print("❗️ 마지막 소셜 로그인 기록을 \(signUpType.rawValue)로 저장합니다.")
        userDefaults.signUpType = signUpType
    }
    
    func signUpType() -> SignUpType {
        print("❗️ 마지막 소셜 로그인 기록은 \(userDefaults.signUpType.rawValue)입니다.")
        return userDefaults.signUpType
    }
}
