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
    case fetchConditionPolicy(page: Int, body: PolicyConditionBody, region: String?)
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
        case .fetchConditionPolicy(let page, let body, let region):
            return convertToParameters(page, body, region)
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
        
        switch self {
        case .fetchConditionPolicy(_, _, _):
            return try? encoder.encode(PolicyConditionBody.init(categories: nil, age: nil, employmentCodeList: nil, isFinished: nil, keyword: nil))
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
    
    private func convertToParameters(_ page: Int, _ body: PolicyConditionBody, _ region: String?) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["page"] = page
        params["size"] = 20
        params["sort"] = "POPULAR"
        
        if let region {
            params["region"] = region            
        }
        
        return params
    }
}
