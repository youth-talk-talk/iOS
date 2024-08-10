//
//  PostRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import Alamofire

enum PostRouter: Router {
    
    var keyChainHelper: KeyChainHelper {
        return KeyChainHelper()
    }
    
    case fetchPost(query: RPQuery)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchPost:
            return "/posts/post"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPost:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchPost(let query):
            return convertToParameters(query)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchPost:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchPost:
            return nil
        }
    }
    
    private func convertToParameters(_ query: RPQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["page"] = query.page
        params["size"] = query.size
        
        return params
    }
}
