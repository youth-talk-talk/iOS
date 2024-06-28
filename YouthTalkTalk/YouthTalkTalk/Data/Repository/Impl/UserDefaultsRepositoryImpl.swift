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
        
        userDefaults.isSignIn = signedInType
    }
    
    func isSignedIn() -> SignInType {
        
        return userDefaults.isSignIn
    }
    
    // MARK: SIGN UP TYPE
    func saveSignUpType(signUpType: SignUpType) {
        
        userDefaults.signUpType = signUpType
    }
    
    func signUpType() -> SignUpType {
        
        return userDefaults.signUpType
    }
}
