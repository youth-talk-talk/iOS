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
    
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
    
    // Inputs
    var fetchPolicies = PublishRelay<Void>()
    
    // Outputs
    var topFivePoliciesRelay = PublishRelay<[HomeSectionItems]>()
    var allPoliciesRelay = PublishRelay<[HomeSectionItems]>()
    
    var topFivePolicies: [HomeSectionItems] = []
    var allPolicies: [HomeSectionItems] = []
    
    init(policyUseCase: PolicyUseCase) {
        self.policyUseCase = policyUseCase
        
        fetchPolicies
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.policyUseCase.fetchHomePolicies(categories: [.job, .life], page: 1, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let homePolicyEntity):
                    
                    let topFivePolicies = homePolicyEntity.topFivePolicies.map { HomeSectionItems.topFive($0) }
                    let allPolicies = homePolicyEntity.allPolicies.map { HomeSectionItems.all($0)}
                    
                    owner.topFivePolicies = topFivePolicies
                    owner.topFivePoliciesRelay.accept(topFivePolicies)
                    
                    owner.allPolicies = allPolicies
                    owner.allPoliciesRelay.accept(allPolicies)
                    
                case .failure(let error):
                    
                    print("실패")
                }
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print("HomeViewModel Deinit")
    }
}
