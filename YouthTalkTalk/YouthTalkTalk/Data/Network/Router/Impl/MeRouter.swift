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
    
    var keyChainHelper: KeyChainHelper {
        return KeyChainHelper()
    }
    
    case requestMe
    case deleteAccount
    case patchMe(ChangedRegion)
    case seePolicies
    case endPolicies
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .requestMe, .deleteAccount, .patchMe:
            return "/members/me"
        case .seePolicies:
            return "/policies/recent-view"
        case .endPolicies:
            return "/policies/scrapped/upcoming-deadline"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestMe, .seePolicies, .endPolicies:
            return .get
        case .deleteAccount:
            return .post  
        case .patchMe:
            return .patch
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .requestMe, .deleteAccount, .patchMe, .seePolicies, .endPolicies:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .requestMe, .deleteAccount, .patchMe, .seePolicies, .endPolicies:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .requestMe, .seePolicies, .endPolicies:
            return nil
        case .deleteAccount:
            // TODO: 애플/ 카카오 로그인 유저 구분해서 바디 생성
            return nil
        case .patchMe(let body):
            return try? encoder.encode(body)
        }
    }
}
