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
    case updatePostScrap(id: String)
    case fetchReviewDetilInfo(id: Int)
    case uploadPostComment(body: UploadPostCommentBody)
    case deletePost(_ postId: String)
    case reportPost(_ postId: Int)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchReview:
            return "/posts/review"
        case .fetchConditionReview:
            return "/posts/keyword"
        case .updatePostScrap(let id):
            return "/posts/\(id)/scrap"
        case .fetchReviewDetilInfo(let id):
            return "/posts/\(id)"
        case .uploadPostComment:
            return "/posts/comments"  
        case .deletePost(let id):
            return "/posts/\(id)"
        case .reportPost(let id):
            return "/report/post/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchReview, .fetchConditionReview, .fetchReviewDetilInfo:
            return .get
        case .updatePostScrap, .uploadPostComment, .reportPost:
            return .post
        case .deletePost:
            return .delete
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchReview(let query):
            return convertToParameters(rpQuery: query)
        case .fetchConditionReview(let query):
            return convertToParameters(conditionQuery: query)
        case .uploadPostComment:
            return nil
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchReview, .fetchConditionReview, .updatePostScrap, .fetchReviewDetilInfo, .uploadPostComment, .deletePost, .reportPost:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchReview, .fetchConditionReview, .updatePostScrap, .fetchReviewDetilInfo, .deletePost, .reportPost:
            return nil
        case .uploadPostComment(let body):
            return try? encoder.encode(body)
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
