//
//  SignUpRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/5/24.
//

import Foundation
import Alamofire

enum SignUpRouter: Router {
    
    case requestAppleSignUp(signUp: SignUpBody)
    case requestKakaoSignUp(signUp: SignUpBody)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .requestAppleSignUp, .requestKakaoSignUp:
            return "/signUp"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAppleSignUp, .requestKakaoSignUp:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .requestAppleSignUp, .requestKakaoSignUp:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .requestAppleSignUp, .requestKakaoSignUp:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .requestAppleSignUp(let signUpBody), .requestKakaoSignUp(let signUpBody):
            return try? encoder.encode(signUpBody)
        }
    }
}
