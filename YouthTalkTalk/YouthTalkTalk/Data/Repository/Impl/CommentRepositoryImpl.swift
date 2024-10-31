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
}
