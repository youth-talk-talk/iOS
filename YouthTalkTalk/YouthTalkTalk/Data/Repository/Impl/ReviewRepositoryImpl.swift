//
//  ReviewRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

final class ReviewRepositoryImpl: ReviewRepository {
    
    private let apiManager = APIManager()
    
    func fetchReviews(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>> {
        
        let categoriesData = categories.map { $0.rawValue }
        
        let rpQuery = RPQuery(page: page, size: size)
        let reviewBody = ReviewBody(categories: categoriesData)
        
        let router = ReviewRouter.fetchReview(query: rpQuery, body: reviewBody)
        
        return apiManager.request(router: router, type: CommunityRPDTO.self).asObservable()
    }
}
