//
//  UserDefaultsHelper.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation

extension UserDefaults {
    
    enum SignInType: String {
        
        static let key: String = "signInType"
        
        case apple
        case kakao
        case none
    }
    
    static var isSignIn: SignInType {
        get {
            guard let signInTypeString = standard.string(forKey: SignInType.key),
                  let signInType = SignInType(rawValue: signInTypeString) else {
                return .none // 기본값 설정
            }
            return signInType
        } set {
            standard.set(newValue.rawValue, forKey: SignInType.key)
        }
    }
}
