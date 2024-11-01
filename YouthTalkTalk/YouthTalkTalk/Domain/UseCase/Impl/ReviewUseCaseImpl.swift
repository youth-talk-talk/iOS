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
                    
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
    
    func fetchConditionReviews(keyword: String, page: Int, size: Int) -> Observable<Result<([RPEntity], Int), APIError>> {
        
        let query = ConditionRPQuery(type: .review, keyword: keyword, size: size, page: page)
        
        return reviewRepository.fetchConditionReviews(conditionRPQuery: query)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                case .success(let conditionReviewDTO):
                    
                    dump(conditionReviewDTO)
                    
                    let total = conditionReviewDTO.data.total
                    let rpEntity = conditionReviewDTO.data.posts.map { $0.translateEntity() }
                    
                    return .success((rpEntity, total))
                    
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
    
    func updateReviewScrap(id: String) -> Observable<Result<ScrapEntity, APIError>> {
        
        reviewRepository.updatePolicyScrap(id: id)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                case .success(let scrapDTO):
                    
                    let scrapEntity = ScrapEntity(isScrap: scrapDTO.message == "스크랩에 성공하였습니다.", id: id)
                    
                    return .success(scrapEntity)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
    func fetchReviewDetail(id: Int) -> Observable<Result<DetailRPEntity, APIError>> {
        
        reviewRepository.fetchReviewDetailInfo(id: id)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                    
                case .success(let detailRPDTO):
                    
                    let entity = detailRPDTO.data.translate()
                    
                    return .success(entity)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
