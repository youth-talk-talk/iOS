//
//  CommentUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation
import RxSwift

protocol CommentUseCase {
    
    func fetchComments(postID: Int) -> Observable<Result<[CommentDetailEntity], APIError>>
}
