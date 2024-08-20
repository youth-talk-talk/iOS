//
//  HomeViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel: HomeInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let policyUseCase: PolicyUseCase
    
    // 선택된 정책 카테고리
    var selectedPolicyCategory: [PolicyCategory] = PolicyCategory.allCases
    var currentPage = 1
    var fetchRecentPolicies = PublishRelay<Void>()
    
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
    
    // Inputs
    var fetchPolicies = PublishRelay<Void>()
    var pageUpdate = PublishRelay<Int>()
    var policyCategorySeleted = PublishRelay<PolicyCategory>()
    var updatePolicyScrap = PublishRelay<String>()
    
    // Outputs
    var popularPoliciesRelay = PublishRelay<[HomeSectionItems]>()
    var recentPoliciesRelay = PublishRelay<[HomeSectionItems]>()
    var resetSectionItems = PublishRelay<Void>()
    var updatePolicyScrapRelay = PublishRelay<Bool>()
    var errorHandler = PublishRelay<APIError>()
    
    init(policyUseCase: PolicyUseCase) {
        self.policyUseCase = policyUseCase
        
        // 기본 10개 정책 호출
        fetchPolicies
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.policyUseCase.fetchHomePolicies(categories: owner.selectedPolicyCategory, page: 1, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let homePolicyEntity):
                    
                    let popularPolicies = homePolicyEntity.popularPolicies.map { HomeSectionItems.popular($0) }
                    let recentPolicies = homePolicyEntity.recentPolicies.map { HomeSectionItems.recent($0)}
                    
                    owner.popularPoliciesRelay.accept(popularPolicies)
                    owner.recentPoliciesRelay.accept(recentPolicies)
                    
                case .failure(let error):
                    print("\(error.msg) - 기본 10개 정책 호출 실패")
                }
            }.disposed(by: disposeBag)
        
        // 스크롤(페이지 변경)을 통한 정책 호출
        pageUpdate
            .distinctUntilChanged()
            .subscribe(with: self) { owner, page in
                
                owner.currentPage = page
                
                owner.fetchRecentPolicies.accept(())
                
            }.disposed(by: disposeBag)
        
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
                owner.fetchRecentPolicies.accept(())
                
            }.disposed(by: disposeBag)
        
        // 스크롤 또는 카테고리 변경 시 최근 정책 업데이트
        fetchRecentPolicies
                .withUnretained(self)
                .flatMap { owner, _ in
                    
                    return owner.policyUseCase.fetchHomePolicies(categories: owner.selectedPolicyCategory, page: owner.currentPage, size: 10)
                }
                .subscribe(with: self) { owner, result in
                    
                    switch result {
                    case .success(let homePolicyEntity):
                        let recentPolicies = homePolicyEntity.recentPolicies.map { HomeSectionItems.recent($0)}
                        
                        owner.recentPoliciesRelay.accept(recentPolicies)
                        
                    case .failure(let error):
                        print(error.msg)
                    }
                }
                .disposed(by: disposeBag)
        
        // 스크랩
        updatePolicyScrap
            .withUnretained(self)
            .flatMap { owner, policyID in
                
                return owner.policyUseCase.updatePolicyScrap(id: policyID)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let isScrap):
                    owner.updatePolicyScrapRelay.accept(isScrap)
                case .failure(let error):
                    owner.errorHandler.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("HomeViewModel Deinit")
    }
}
