//
//  PostUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostUseCaseImpl: PostUseCase {
    
    private let disposeBag = DisposeBag()
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func fetchPosts(page: Int, size: Int) -> Observable<Result<CommunityRPEntity, APIError>> {
        
        return postRepository.fetchPosts(page: page, size: size)
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
    
    func fetchConditionPosts(keyword: String, page: Int, size: Int) -> Observable<Result<([RPEntity], Int), APIError>> {
        
        let query = ConditionRPQuery(type: .post, keyword: keyword, size: size, page: page)
        
        return postRepository.fetchConditionPosts(conditionRPQuery: query)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                case .success(let conditionReviewDTO):
                    
                    let total = conditionReviewDTO.data.total
                    let rpEntity = conditionReviewDTO.data.posts.map { $0.translateEntity() }
                    
                    return .success((rpEntity, total))
                    
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
    
    func fetchScrapPosts(page: Int, size: Int) -> Observable<Result<[RPEntity], APIError>> {
        
        return postRepository.fetchScrapPosts(page: page, size: size)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                case .success(let scrapPostDTO):
                    
                    let items = scrapPostDTO.data.map { $0.translateEntity() }
                    
                    return .success(items)
                    
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
    
    func updatePostScrap(id: String) -> Observable<Result<ScrapEntity, APIError>> {
        
        postRepository.updatePolicyScrap(id: id)
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
}
