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
    func updateReviewScrap(id: String) -> Observable<Result<ScrapEntity, APIError>>
    // func fetchReviewDetail(id: String) -> Observable<Result<DetailPolicyEntity, APIError>>
}
