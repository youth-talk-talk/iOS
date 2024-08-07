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

extension UserDefaults {
    
    // MARK: SIGN UP TYPE
    func saveSignUpType(signUpType: SignUpType) {
        print("❗️ 마지막 소셜 로그인 기록을 \(signUpType.rawValue)로 저장합니다.")
        self.signUpType = signUpType
    }
}
