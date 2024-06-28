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
}
