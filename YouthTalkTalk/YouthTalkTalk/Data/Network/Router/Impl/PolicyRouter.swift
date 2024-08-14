//
//  PolicyRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import Alamofire

enum PolicyRouter: Router {
    
    var keyChainHelper: KeyChainHelper {
        return KeyChainHelper()
    }
    
    case fetchHomePolicy(policy: PolicyQuery)
    case fetchPolicyDetail(id: String)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchHomePolicy:
            return "/policies"
        case .fetchPolicyDetail(let id):
            return "/policies/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomePolicy, .fetchPolicyDetail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchHomePolicy(let body):
            return convertToParameters(body)
        case .fetchPolicyDetail:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchHomePolicy, .fetchPolicyDetail:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchHomePolicy, .fetchPolicyDetail:
            return nil
        }
    }
    
    private func convertToParameters(_ query: PolicyQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        query.categories.forEach { category in
            if params["categories"] == nil {
                params["categories"] = category.rawValue
            } else {
                params["categories"] = params["categories"] as! String + ",\(category.rawValue)"
            }
        }
        params["page"] = query.page
        params["size"] = query.size
        
        return params
    }
}
