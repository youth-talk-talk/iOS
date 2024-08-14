//
//  ReviewRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import Alamofire

enum ReviewRouter: Router {
    
    var keyChainHelper: KeyChainHelper {
        return KeyChainHelper()
    }
    
    case fetchReview(query: RPQuery)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchReview:
            return "/posts/review"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchReview:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchReview(let query):
            return convertToParameters(query)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchReview:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchReview:
            return nil
        }
    }
    
    private func convertToParameters(_ query: RPQuery) -> [String: Any] {
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
