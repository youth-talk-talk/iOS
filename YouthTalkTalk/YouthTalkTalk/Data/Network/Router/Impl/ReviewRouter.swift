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
    
    case fetchReview(query: RPQuery, body: ReviewBody)
    
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
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchReview(let query, _):
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
        case .fetchReview(_, let body):
            return try? encoder.encode(body)
        }
    }
    
    private func convertToParameters(_ query: RPQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["page"] = query.page
        params["size"] = query.size
        
        return params
    }
}
