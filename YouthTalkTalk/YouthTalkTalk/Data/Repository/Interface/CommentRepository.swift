//
//  CommentRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import RxSwift

protocol CommentRepository {
    func commentDelete(_ commentId: Int) -> Observable<Result<CommentDeleteDTO, APIError>>
    func fetchComments(postID: Int) -> Observable<Result<CommentDTO, APIError>>
}
