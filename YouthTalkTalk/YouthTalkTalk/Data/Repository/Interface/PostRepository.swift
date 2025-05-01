//
//  PostRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

protocol PostRepository {
    
    func fetchPosts(page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>>
    func fetchConditionPosts(conditionRPQuery: ConditionRPQuery) -> Observable<Result<ConditionReviewDTO, APIError>>
    func updatePolicyScrap(id: String) -> Observable<Result<ScrapDTO, APIError>>
    func fetchLikedComment() -> Observable<Result<LikedComment, APIError>>
    func fetchMyComment() -> Observable<Result<LikedComment, APIError>>
    func fetchMyPost(_ page: Int) -> Observable<Result<MyPost, APIError>>
    func fetchScrapPosts(page: Int, size: Int) -> Observable<Result<ScrapPostDTO, APIError>>
}
