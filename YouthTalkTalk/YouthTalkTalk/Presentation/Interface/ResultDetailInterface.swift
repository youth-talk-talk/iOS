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
}

protocol ResultDetailOutput {
    var writtenCommentText: String { get }
    var commentWriterName: String { get }
    var successUploadComment: PassthroughSubject<Void, Never> { get }
    var detailInfo: PublishRelay<DetailRPEntity> { get }
    var commentsInfo: PublishRelay<[CommentDetailEntity]> { get }
    var rpEntity: RPEntity { get }
    
    func uploadPostComment(_ body: UploadPostCommentBody)
}

protocol ResultDetailInterface: ResultDetailInput, ResultDetailOutput {
    
    var input: ResultDetailInput { get }
    var output: ResultDetailOutput { get }
}
