//
//  ReviewUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewUseCase {
    
    func fetchReviews(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<CommunityRPEntity, APIError>>
    func fetchConditionReviews(keyword: String, page: Int, size: Int) -> Observable<Result<([RPEntity], Int), APIError>>
    func updatePostScrap(id: String) -> Observable<Result<ScrapEntity, APIError>>
    func fetchReviewDetail(id: Int) -> Observable<Result<DetailRPEntity, APIError>>
    func uploadPostComment(_ body: UploadPostCommentBody) -> Observable<Result<UploadPostCommentDTO, APIError>>
}
