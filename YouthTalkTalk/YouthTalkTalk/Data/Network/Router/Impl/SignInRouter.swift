//
//  SignInRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import Foundation
import Alamofire

enum SignInRouter: Router {
    
    case requestAppleSignIn(signIn: SignInBody)
    case requestKakaoSignIn(signIn: SignInBody)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .requestAppleSignIn, .requestKakaoSignIn:
            return "/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAppleSignIn, .requestKakaoSignIn:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .requestAppleSignIn, .requestKakaoSignIn:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .requestAppleSignIn, .requestKakaoSignIn:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .requestAppleSignIn(let signInBody), .requestKakaoSignIn(let signInBody):
            return try? encoder.encode(signInBody)
        }
    }
    
}
