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
    case deleteComment(_ commentId: Int)
    case editComment(_ commentId: Int, _ newComment: String)
    case likeComment(_ commentId: Int, _ isSetLiked: Bool)
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var path: String {
        switch self {
        case .fetchComment(let postID):
            return "/posts/\(postID)/comments" 
        case .deleteComment(let commentId):
            return "comments/\(commentId)"
        case .editComment:
            return "/comments"      
        case .likeComment:
            return "/comments/likes"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchComment:
            return .get  
        case .deleteComment:
            return .delete
        case .editComment:
            return .patch   
        case .likeComment:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default: return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchComment, .deleteComment, .editComment, .likeComment:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(keyChainHelper.loadTokenInfo(type: .accessToken))"]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        switch self {
        case .fetchComment, .deleteComment:
            return nil
            
        case.editComment(let commentId, let newComment):
            return try? encoder.encode(EditComment(commentId: commentId, content: newComment))  
            
        case.likeComment(let commentId, let isSetLiked):
            return try? encoder.encode(LikeComment(commentId: commentId, isSetLiked: isSetLiked))
        }
    }
}

// MARK: 인코딩 모델
struct EditComment: Encodable {
    let commentId: Int
    let content: String
}

struct LikeComment: Encodable {
    let commentId: Int
    let isSetLiked: Bool
}
