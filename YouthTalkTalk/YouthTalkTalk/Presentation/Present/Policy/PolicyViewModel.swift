//
//  PolicyViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation
import RxCocoa
import RxSwift

final class PolicyViewModel: DetailPolicyInterface {
    
    private let disposeBag = DisposeBag()
    
    let policyID: String
    let policyUseCase: PolicyUseCase
    
    var input: DetailPolicyInput { return self }
    var output: DetailPolicyOutput { return self }
    
    // MARK: INPUT
    var fetchPolicyDetail = PublishRelay<String>()
    
    // MARK: OUTPUT
    var summarySectionRelay = PublishRelay<[PolicySectionItems]>()
    var detailSectionRelay = PublishRelay<[PolicySectionItems]>()
    var methodSectionRelay = PublishRelay<[PolicySectionItems]>()
    var targetSectionRelay = PublishRelay<[PolicySectionItems]>()
    
    init(policyID: String, policyUseCase: PolicyUseCase) {
        self.policyID = policyID
        self.policyUseCase = policyUseCase
        
        fetchPolicyDetail
            .withUnretained(self)
            .flatMap { owner, id in
                
                return owner.policyUseCase.fetchPolicyDetail(id: id)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let policyDetailEntity):
                    
                    let summary = [policyDetailEntity.summary].map { PolicySectionItems.summary($0) }
                    let detail = [policyDetailEntity.detail].map { PolicySectionItems.detail($0) }
                    let method = [policyDetailEntity.method].map { PolicySectionItems.method($0) }
                    let target = [policyDetailEntity.target].map { PolicySectionItems.target($0) }
                    let isScrap = policyDetailEntity.isScrap
                    
                    owner.summarySectionRelay.accept(summary)
                    owner.detailSectionRelay.accept(detail)
                    owner.methodSectionRelay.accept(method)
                    owner.targetSectionRelay.accept(target)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
