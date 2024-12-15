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
    case fetchConditionPost(query: ConditionRPQuery)
    case updatePostScrap(id: String)
    case fetchScrapPost(query: RPQuery)
    case fetchLikedComment
    case fetchMyComment
    case fetchMyPost(page: Int)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchPost:
            return "/posts/post"
        case .fetchConditionPost:
            return "/posts/keyword"
        case .updatePostScrap(let id):
            return "/posts/\(id)/scrap"
        case .fetchScrapPost:
            return "/posts/scrap"   
        case .fetchLikedComment:
            return "/members/me/comments/likes"     
        case .fetchMyComment:
            return "/members/me/comments"  
        case .fetchMyPost:
            return "/posts/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPost, .fetchConditionPost, .fetchScrapPost, .fetchLikedComment, .fetchMyComment, .fetchMyPost:
            return .get
        case .updatePostScrap:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchPost(let query), .fetchScrapPost(let query):
            return convertToParameters(query)
        case .fetchConditionPost(let query):
            return convertToParameters(conditionQuery: query)
        case .fetchMyPost(let page):
            return convertToParameters(RPQuery(categories: [], page: page, size: 10))
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchPost, .fetchConditionPost, .updatePostScrap, .fetchScrapPost, .fetchLikedComment, .fetchMyComment, .fetchMyPost:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        default:
            return nil
        }
    }
    
    private func convertToParameters(_ query: RPQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["page"] = query.page
        params["size"] = query.size
        
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
