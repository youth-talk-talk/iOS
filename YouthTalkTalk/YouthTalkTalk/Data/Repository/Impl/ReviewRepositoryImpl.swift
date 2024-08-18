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
        
        let rpQuery = RPQuery(categories: categories, page: page, size: size)
        
        let router = ReviewRouter.fetchReview(query: rpQuery)
        
        return apiManager.request(router: router, type: CommunityRPDTO.self).asObservable()
    }
}
