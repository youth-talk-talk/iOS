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
    
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
    
    // Inputs
    var fetchPolicies = PublishRelay<Void>()
    var updateRecentPolicies = PublishRelay<Int>()
    var policyCategorySeleted = PublishRelay<PolicyCategory>()
    
    // Outputs
    var topFivePoliciesRelay = PublishRelay<[HomeSectionItems]>()
    var allPoliciesRelay = PublishRelay<[HomeSectionItems]>()
    var resetSectionItems = PublishRelay<Void>()
    
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
                    
                    let topFivePolicies = homePolicyEntity.topFivePolicies.map { HomeSectionItems.topFive($0) }
                    let allPolicies = homePolicyEntity.allPolicies.map { HomeSectionItems.all($0)}
                    
                    owner.topFivePoliciesRelay.accept(topFivePolicies)
                    owner.allPoliciesRelay.accept(allPolicies)
                    
                case .failure(let error):
                    
                    print("기본 10개 정책 호출 실패")
                }
            }.disposed(by: disposeBag)
        
        // 스크롤(페이지 변경)을 통한 정책 호출
        updateRecentPolicies
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, page in
                
                return owner.policyUseCase.fetchHomePolicies(categories: owner.selectedPolicyCategory, page: page, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let homePolicyEntity):
                    
                    let allPolicies = homePolicyEntity.allPolicies.map { HomeSectionItems.all($0)}
                    
                    owner.allPoliciesRelay.accept(allPolicies)
                    
                case .failure(let error):
                    
                    print("스크롤(페이지 변경)을 통한 정책 호출 실패")
                }
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
                
                // 새로운 데이터 호출
                owner.fetchPolicies.accept(())
                
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print("HomeViewModel Deinit")
    }
}
