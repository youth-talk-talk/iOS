//
//  UserDefaultsHelper.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation

enum SignInType: String {
    
    static let key: String = "signInType"
    
    case apple
    case kakao
    case none
}

enum SignUpType: String {
    
    static let key: String = "signUpType"
    
    case apple
    case kakao
}

extension UserDefaults {
    
    var isSignIn: SignInType {
        get {
            guard let signInTypeString = string(forKey: SignInType.key),
                  let signInType = SignInType(rawValue: signInTypeString) else {
                return .none // 기본값 설정
            }
            return signInType
        } set {
            set(newValue.rawValue, forKey: SignInType.key)
        }
    }
    
    var signUpType: SignUpType {
        get {
            guard let signUpTypeString = string(forKey: SignUpType.key),
                  let signUpType = SignUpType(rawValue: signUpTypeString) else {
                return .apple
            }
            return signUpType
        } set {
            set(newValue.rawValue, forKey: SignUpType.key)
        }
    }
}
