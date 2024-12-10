//
//  CommentRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import RxSwift

protocol CommentRepository {
    func commentDelete(_ commentId: Int) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>>
    func fetchComments(postID: Int) -> Observable<Result<CommentDTO, APIError>>
    func editComment(_ commentId: Int, _ newComment: String) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>>
    func likeComment(_ commentId: Int, _ isSetLiked: Bool) -> Observable<Result<CommentDeleteEditLikeDTO, APIError>>
}
