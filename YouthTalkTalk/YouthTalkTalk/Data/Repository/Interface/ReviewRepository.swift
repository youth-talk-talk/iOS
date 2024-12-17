//
//  ReviewRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

protocol ReviewRepository {
    
    func fetchReviews(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>>
    func fetchConditionReviews(conditionRPQuery: ConditionRPQuery) -> Observable<Result<ConditionReviewDTO, APIError>>
    func updatePostScrap(id: String) -> Observable<Result<ScrapDTO, APIError>>
    func fetchReviewDetailInfo(id: Int) -> Observable<Result<DetailRPDTO, APIError>>
    func uploadPostComment(_ body: UploadPostCommentBody) -> Observable<Result<UploadPostCommentDTO, APIError>>
    func deletePost(_ postId: String) -> Observable<Result<DeleteAccountDTO, APIError>>
    func reportPost(_ postId: Int) -> Observable<Result<DeleteAccountDTO, APIError>>
}
