//
//  PostRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

final class PostRepositoryImpl: PostRepository {
    
    private let apiManager = APIManager()
    
    func fetchPosts(page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>> {
        
        let rpQuery = RPQuery(categories: [], page: page, size: size)
        
        let router = PostRouter.fetchPost(query: rpQuery)
        
        return apiManager.request(router: router, type: CommunityRPDTO.self).asObservable()
    }
    
    func fetchConditionPosts(conditionRPQuery: ConditionRPQuery) -> Observable<Result<ConditionReviewDTO, APIError>> {
        
        let router = PostRouter.fetchConditionPost(query: conditionRPQuery)
        
        return apiManager.request(router: router, type: ConditionReviewDTO.self).asObservable()
    }
    
    func updatePolicyScrap(id: String) -> Observable<Result<ScrapDTO, APIError>> {
        
        let router = PostRouter.updatePostScrap(id: id)
        
        return apiManager.request(router: router, type: ScrapDTO.self).asObservable()
    }
}
