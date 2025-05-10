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
    case fetchConditionPolicy(param: [String: String], body: PolicyConditionBody?)
    case fetchPolicyDetail(id: String)
    case updatePolicyScrap(id: String)
    case fetchUpComingDeadlineScrap
    case fetchScrapPolicy
    case uploadImage(image: String)
    case uploadPost(body: UploadPostBody)
    case editPost(_ postId: Int, _ postData: PostEditRequestModel)
    
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
        case .fetchUpComingDeadlineScrap:
            return "policies/scrapped/upcoming-deadline"
        case .fetchScrapPolicy:
            return "policies/scrap"
        case .uploadImage:
            return "/posts/image"
        case .uploadPost:
            return "/posts"
        case .editPost(let postId, _):
            return "/posts/\(postId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomePolicy, .fetchPolicyDetail, .fetchUpComingDeadlineScrap, .fetchScrapPolicy :
            return .get
        case .fetchConditionPolicy, .updatePolicyScrap, .uploadImage, .uploadPost:
            return .post
        case .editPost:
            return .patch
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchHomePolicy(let query):
            return convertToParameters(query)
        case .fetchConditionPolicy(let param, _):
            return param
        case .fetchPolicyDetail, .updatePolicyScrap, .fetchUpComingDeadlineScrap, .fetchScrapPolicy, .uploadImage, .uploadPost, .editPost:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchHomePolicy, .fetchConditionPolicy, .fetchPolicyDetail, .updatePolicyScrap, .fetchUpComingDeadlineScrap, .fetchScrapPolicy, .uploadPost, .editPost:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
            
        case .uploadImage:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        struct EmptyModel: Encodable { }
        
        switch self {
        case .fetchConditionPolicy(_, let body):
            return try? encoder.encode(body == nil ? .init(category: nil,
                                                           age: nil,
                                                           employmentCodeList: nil,
                                                           isFinished: nil,
                                                           keyword: nil) : body)
        case .uploadImage(let image):
            return try? encoder.encode(image)
        case .uploadPost(let body):
            return try? encoder.encode(body)
        case .editPost(_, let body):
            return try? encoder.encode(body)
        case .fetchHomePolicy, .fetchPolicyDetail, .updatePolicyScrap, .fetchUpComingDeadlineScrap, .fetchScrapPolicy:
            return nil
        }
    }
    
    private func convertToParameters(_ query: PolicyQuery) -> [String: Any] {
        var params: [String: Any] = [:]
        
        // 카테고리를 하나도 선택하지 않은 경우에는 모든 카테고리의 정책을 불러옴
        if query.categories.isEmpty {
            params["categories"] = "JOB,EDUCATION,LIFE,PARTICIPATION"
        }
        
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
