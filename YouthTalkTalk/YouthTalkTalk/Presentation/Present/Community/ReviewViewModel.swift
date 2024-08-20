//
//  CommunityViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReviewViewModel: RPInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let useCase: ReviewUseCase
    
    var type: MainContentsType = .review
    
    // 선택된 정책 카테고리
    var selectedPolicyCategory: [PolicyCategory] = PolicyCategory.allCases
    
    var fetchRPs = PublishRelay<Void>()
    var updateRecentRPs = PublishRelay<Int>()
    var policyCategorySeleted: PublishRelay<PolicyCategory>? = PublishRelay<PolicyCategory>()
    
    var popularRPsRelay = PublishRelay<[CommunitySectionItems]>()
    var recentRPsRelay = PublishRelay<[CommunitySectionItems]>()
    
    var input: RPInput { return self }
    var output: RPOutput { return self }
    
    init(rpUseCase: ReviewUseCase) {
        self.useCase = rpUseCase
        
        fetchRPs
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.useCase.fetchReviews(categories: owner.selectedPolicyCategory, page: 1, size: 10)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let communityRPEntity):
                    
                    let popular = communityRPEntity.popularRP.map { CommunitySectionItems.popular($0) }
                    let recent = communityRPEntity.recentRP.map { CommunitySectionItems.recent($0) }
                    
                    owner.popularRPsRelay.accept(popular)
                    owner.recentRPsRelay.accept(recent)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
