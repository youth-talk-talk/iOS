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
    var pageUpdate = PublishRelay<Int>()
    var searchType: ResultSearchType = .policy
    var updatePolicyScrap = PublishRelay<String>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var totalCountRelay = PublishRelay<Int>()
    var errorHandler = PublishRelay<APIError>()
    var scrapStatus = [String: Bool]()
    var scrapStatusRelay = BehaviorRelay<[String: Bool]>(value: [:])
    
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
                case .success(let data):
                    
                    let (policyEntity, totalCount) = data
                    
                    let recentPolicies = policyEntity.map { ResultSearchSectionItems.resultPolicy($0) }
                    
                    owner.searchListRelay.accept(recentPolicies)
                    owner.totalCountRelay.accept(totalCount)
                    
                case .failure(let error):
                    
                    owner.errorHandler.accept(error)
                }
            }.disposed(by: disposeBag)
        
        pageUpdate
            .distinctUntilChanged()
            .subscribe(with: self) { owner, newPage in
                
                owner.page = newPage
                owner.fetchSearchList.accept(())
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
                case .success(let scrapEntity):
                    
                    owner.scrapStatus[scrapEntity.id] = scrapEntity.isScrap
                    owner.scrapStatusRelay.accept(owner.scrapStatus)
                    
                case .failure(let error):
                    owner.errorHandler.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func updateData(age: Int?, employment: [String], isFinished: Bool?) {
        body.age = age
        body.employmentCodeList = employment
        body.isFinished = isFinished
        
        pageUpdate.accept(0)
    }
    
    func fetchPage() -> Int {
        return page
    }
}
