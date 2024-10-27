//
//  CommentRouter.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import Alamofire

enum CommentRouter: Router {
    
    var keyChainHelper: KeyChainHelper {
        return KeyChainHelper()
    }
    
    case fetchComment(postID: Int)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchComment(let postID):
            return "/posts/\(postID)/comments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchComment:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default: return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchComment:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchComment:
            return nil
        }
    }
}
