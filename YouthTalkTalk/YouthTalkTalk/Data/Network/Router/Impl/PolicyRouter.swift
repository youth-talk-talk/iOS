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
    case fetchConditionPolicy(page: Int, body: PolicyConditionBody)
    case fetchPolicyDetail(id: String)
    case updatePolicyScrap(id: String)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchHomePolicy:
            return "/policies"
        case .fetchConditionPolicy:
            return "/policies/search"
        case .fetchPolicyDetail(let id):
            return "/policies/\(id)"
        case .updatePolicyScrap(let id):
            return "/policies/\(id)/scrap"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomePolicy, .fetchPolicyDetail:
            return .get
        case .fetchConditionPolicy, .updatePolicyScrap:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchHomePolicy(let query):
            return convertToParameters(query)
        case .fetchConditionPolicy(let page, _):
            return convertToParameters(page)
        case .fetchPolicyDetail, .updatePolicyScrap:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchHomePolicy, .fetchConditionPolicy, .fetchPolicyDetail, .updatePolicyScrap:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchConditionPolicy(_, let body):
            return try? encoder.encode(body)
        case .fetchHomePolicy, .fetchPolicyDetail, .updatePolicyScrap:
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
    
    private func convertToParameters(_ page: Int) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["page"] = page
        params["size"] = 10
        
        return params
    }
}
