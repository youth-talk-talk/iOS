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
    case fetchConditionReview(query: ConditionRPQuery)
    case updateReviewScrap(id: String)
    case fetchReviewDetilInfo(id: Int)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchReview:
            return "/posts/review"
        case .fetchConditionReview:
            return "/posts/keyword"
        case .updateReviewScrap(let id):
            return "/posts/\(id)/scrap"
        case .fetchReviewDetilInfo(let id):
            return "/posts/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchReview, .fetchConditionReview, .fetchReviewDetilInfo:
            return .get
        case .updateReviewScrap:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchReview(let query):
            return convertToParameters(rpQuery: query)
        case .fetchConditionReview(let query):
            return convertToParameters(conditionQuery: query)
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchReview, .fetchConditionReview, .updateReviewScrap, .fetchReviewDetilInfo:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchReview, .fetchConditionReview, .updateReviewScrap, .fetchReviewDetilInfo:
            return nil
        }
    }
    
    private func convertToParameters(rpQuery: RPQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        rpQuery.categories.forEach { category in
            if params["categories"] == nil {
                params["categories"] = category.rawValue
            } else {
                params["categories"] = params["categories"] as! String + ",\(category.rawValue)"
            }
        }
        
        params["page"] = rpQuery.page
        params["size"] = rpQuery.size
        
        return params
    }
    
    private func convertToParameters(conditionQuery: ConditionRPQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["type"] = conditionQuery.type.key
        params["keyword"] = conditionQuery.keyword
        params["page"] = conditionQuery.page
        params["size"] = conditionQuery.size
        
        return params
    }
}
