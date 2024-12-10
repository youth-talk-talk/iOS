//
//  File.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import RxSwift

final class CommentRepositoryImpl: CommentRepository {
    private let apiManager = APIManager()
    
    func fetchComments(postID: Int) -> Observable<Result<CommentDTO, APIError>> {
        
        let router = CommentRouter.fetchComment(postID: postID)
        
        return apiManager.request(router: router, type: CommentDTO.self).asObservable()
    }
    
    func commentDelete(_ commentId: Int) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>> {
        
        let router = CommentRouter.deleteComment(commentId)
        
        return apiManager.request(router: router, type: CommentDeleteEditLikeDTO.self).asObservable()
    }
    
    func editComment(_ commentId: Int, _ newComment: String) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>> {
        
        let router = CommentRouter.editComment(commentId, newComment)
        
        return apiManager.request(router: router, type: CommentDeleteEditLikeDTO.self).asObservable()
    }    
    
    func likeComment(_ commentId: Int, _ isSetLiked: Bool) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>> {
        
        let router = CommentRouter.likeComment(commentId, isSetLiked)
        
        return apiManager.request(router: router, type: CommentDeleteEditLikeDTO.self).asObservable()
    }
}
