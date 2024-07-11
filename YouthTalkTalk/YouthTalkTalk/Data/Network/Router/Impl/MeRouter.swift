//
//  MeRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/10/24.
//

import Foundation

import Foundation
import Alamofire

enum MeRouter: Router {
    
    case requestMe
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .requestMe:
            return "/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestMe:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .requestMe:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .requestMe:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(KeyChainHelper().loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .requestMe:
            return nil
        }
    }
}
