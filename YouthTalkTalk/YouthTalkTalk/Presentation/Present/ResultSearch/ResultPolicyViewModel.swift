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
    
    private var page = 0
    private var body = PolicyConditionBody(categories: [], age: nil, employmentCodeList: [], isFinished: nil, keyword: "")
    
    // Input
    var keyword: String
    var fetchSearchList = PublishRelay<Void>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var errorHandler = PublishRelay<APIError>()
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    init(keyword: String = "", type: [PolicyCategory], policyUseCase: PolicyUseCase) {
        self.keyword = keyword
        self.type = type
        self.policyUseCase = policyUseCase
        
        fetchSearchList
            .withUnretained(self)
            .flatMap { owner, _ in
                
                owner.body.categories = type.map { $0.rawValue }
                owner.body.keyword = owner.keyword
                
                return owner.policyUseCase.fetchConditionPolicies(page: owner.page, body: owner.body)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let policyEntity):
                    
                    let recentPolicies = policyEntity.map { ResultSearchSectionItems.resultPolicy($0) }
                    
                    owner.searchListRelay.accept(recentPolicies)
                    
                case .failure(let error):
                    
                    owner.errorHandler.accept(error)
                }
            }.disposed(by: disposeBag)
    }
}
