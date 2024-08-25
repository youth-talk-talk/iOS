//
//  ResultPolicyViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResultPolicyViewModel: ResultSearchInterface {
    
    private var disposeBag = DisposeBag()
    private var type: [PolicyCategory] = PolicyCategory.allCases
    private let policyUseCase: PolicyUseCase
    
    // Input
    var fetchSearchList = PublishRelay<Void>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var errorHandler = PublishRelay<APIError>()
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    init(type: [PolicyCategory], policyUseCase: PolicyUseCase) {
        self.type = type
        self.policyUseCase = policyUseCase
        
        fetchSearchList
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.policyUseCase.fetchHomePolicies(categories: owner.type, page: 1, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let homePolicyEntity):
                    
                    let recentPolicies = homePolicyEntity.recentPolicies.map { ResultSearchSectionItems.resultPolicy($0) }
                    
                    owner.searchListRelay.accept(recentPolicies)
                    
                case .failure(let error):
                    
                    owner.errorHandler.accept(error)
                }
            }.disposed(by: disposeBag)
    }
}
