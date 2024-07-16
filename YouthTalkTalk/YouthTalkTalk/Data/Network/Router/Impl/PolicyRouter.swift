//
//  PolicyRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import Alamofire

enum PolicyRouter: Router {
    
    var keyChainRepository: KeyChainRepository {
        return KeyChainRepositoryImpl()
    }
    
    case fetchHomePolicy(homePolicy: HomePolicyBody)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchHomePolicy:
            return "/policies"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomePolicy:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchHomePolicy(let body):
            return convertToParameters(body)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchHomePolicy(_):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainRepository.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchHomePolicy(_):
            return nil
        }
    }
    
    private func convertToParameters(_ body: HomePolicyBody) -> [String: Any] {
        var params: [String: Any] = [:]
        
        body.categories.forEach { category in
            if params["categories"] == nil {
                params["categories"] = category.rawValue
            } else {
                params["categories"] = params["categories"] as! String + ",\(category.rawValue)"
            }
        }
        params["page"] = body.page
        params["size"] = body.size
        
        return params
    }
}
