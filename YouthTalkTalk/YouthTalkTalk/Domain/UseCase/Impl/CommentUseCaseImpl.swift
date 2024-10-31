//
//  CommentUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import RxSwift

final class CommentUseCaseImpl: CommentUseCase {
    
    private let disposeBag = DisposeBag()
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func fetchComments(postID: Int) -> Observable<Result<[CommentDetailEntity], APIError>> {
        
        return commentRepository.fetchComments(postID: postID)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                    
                case .success(let commentDTO):
                    
                    let comments = commentDTO.data.map { $0.translate() }
                    
                    return .success(comments)
                    
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
