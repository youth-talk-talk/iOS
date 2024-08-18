//
//  ReviewUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReviewUseCaseImpl: ReviewUseCase {
    
    private let disposeBag = DisposeBag()
    private let reviewRepository: ReviewRepository
    
    init(reviewRepository: ReviewRepository) {
        self.reviewRepository = reviewRepository
    }
    
    func fetchReviews(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<CommunityRPEntity, APIError>> {
            
        return reviewRepository.fetchReviews(categories: categories, page: page, size: size)
            .withUnretained(self)
            .map { owenr, result in
                
                switch result {
                case .success(let communityRPDTO):
                    
                    let popular = communityRPDTO.data.popularPosts.map { $0.translateEntity() }
                    let recent = communityRPDTO.data.recentPosts.map { $0.translateEntity() }
                    
                    return .success(CommunityRPEntity(popularRP: popular, recentRP: recent))
                    
                case .failure(let failure):
                    
                    return .failure(failure)
                }
            }
    }
}
