//
//  ResultDetailInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

protocol ResultDetailInput {
    var fetchDetailInfo: PublishRelay<Void> { get }
    
    func commentDelete(_ commentId: Int)
    func likeComment(_ commentId: Int, _ isSetLiked: Bool)
}

protocol ResultDetailOutput {
    var writtenCommentText: String { get }
    var commentWriterName: String { get }
    
    var successUploadComment: PassthroughSubject<Int, Never> { get }
    var successDeleteComment: PassthroughSubject<Int, Never> { get }
    var successEditComment: PassthroughSubject<(commentId: Int, newComment: String), Never> { get }
    var successLikeComment: PassthroughSubject<(commentId: Int, isLiked: Bool), Never> { get }
    
    var detailInfo: PublishRelay<DetailRPEntity> { get }
    var commentsInfo: PublishRelay<[CommentDetailEntity]> { get }
    var rpEntity: RPEntity { get }
    var userNickName: String { get }
    
    func uploadPostComment(_ body: UploadPostCommentBody)
    func editComment(commentId: Int, newComment: String)
}

protocol ResultDetailInterface: ResultDetailInput, ResultDetailOutput {
    
    var input: ResultDetailInput { get }
    var output: ResultDetailOutput { get }
}
