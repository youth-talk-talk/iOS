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
    var currentPage = 1
    var fetchRecentReview = PublishRelay<Void>()
    
    // 선택된 정책 카테고리
    var selectedPolicyCategory: [PolicyCategory] = PolicyCategory.allCases
    
    var fetchRPs = PublishRelay<Void>()
    var updateRecentRPs = PublishRelay<Int>()
    var policyCategorySeleted = PublishRelay<PolicyCategory>()
    var pageUpdate = PublishRelay<Int>()
    
    var popularRPsRelay = PublishRelay<[CommunitySectionItems]>()
    var recentRPsRelay = PublishRelay<[CommunitySectionItems]>()
    var resetSectionItems = PublishRelay<Void>()
    
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
        
        // 카테고리 변경
        policyCategorySeleted
            .subscribe(with: self) { owner, category in
                
                if let index = owner.selectedPolicyCategory.firstIndex(of: category) {
                    // 카테고리가 이미 선택되어 있으면 삭제
                    owner.selectedPolicyCategory.remove(at: index)
                } else {
                    // 카테고리가 선택되어 있지 않으면 추가
                    owner.selectedPolicyCategory.append(category)
                }
                
                // 기존 데이터는 모두 삭제
                owner.resetSectionItems.accept(())
                
                // 페이지 리셋
                owner.currentPage = 1
                
                // 새로운 데이터 호출
                owner.fetchRPs.accept(())
                
            }.disposed(by: disposeBag)
        
        // 스크롤(페이지 변경)을 통한 정책 호출
        pageUpdate
            .distinctUntilChanged()
            .subscribe(with: self) { owner, page in
                
                if page == 1 { return }
                
                owner.currentPage = page
                
                owner.fetchRecentReview.accept(())
                
            }.disposed(by: disposeBag)
        
        // 스크롤 또는 카테고리 변경 시 최근 정책 업데이트
        fetchRecentReview
                .withUnretained(self)
                .flatMap { owner, _ in
                    
                    return owner.useCase.fetchReviews(categories: owner.selectedPolicyCategory, page: owner.currentPage, size: 10)
                }
                .subscribe(with: self) { owner, result in
                    
                    switch result {
                    case .success(let communityRPEntity):
                        
                        let recent = communityRPEntity.recentRP.map { CommunitySectionItems.recent($0) }
                        
                        owner.recentRPsRelay.accept(recent)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
    }
}
