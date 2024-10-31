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

enum MainContentsType: Encodable {
    
    case policy
    case review
    case post
    
    var key: String {
        switch self {
        case .policy:
            return "policy"
        case .review:
            return "review"
        case .post:
            return "post"
        }
    }
    
    var title: String {
        switch self {
        case .policy:
            return ""
        case .review:
            return "후기게시판"
        case .post:
            return "자유게시판"
        }
    }
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
    
    func saveRecentSearch(searchText: String, type: MainContentsType) {
        
        var list: [String] = self.array(forKey: type.key) as? [String] ?? [String]()
        
        if let idx = list.firstIndex(of: searchText) {
            list.swapAt(idx, 0)
        } else {
            list.insert(searchText, at: 0)
        }
        
        while list.count > 5 {
            list.removeLast()
        }
        
        set(list, forKey: type.key)
    }
    
    func removeRecentSearch(searchText: String, type: MainContentsType) {
        
        var list: [String] = self.array(forKey: type.key) as? [String] ?? [String]()
        
        if let idx = list.firstIndex(of: searchText) {
            list.remove(at: idx)
        }
        
        set(list, forKey: type.key)
    }
    
    func fetchRecentSearchList(type: MainContentsType) -> [String] {
        
        return self.array(forKey: type.key) as? [String] ?? [String]()
    }
}
