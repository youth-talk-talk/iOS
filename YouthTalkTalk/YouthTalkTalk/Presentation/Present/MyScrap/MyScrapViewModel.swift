//
//  MyScrapViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyScrapViewModel: MyScrapInterface {
    
    private var disposeBag = DisposeBag()
    private var useCase: PolicyUseCase
    
    var input: MyScrapInput { return self }
    var output: MyScrapOutput { return self }
    
    // Inputs
    var fetchScrapPoliciesEvent = PublishRelay<Void>()
    var updatePolicyScrap = PublishRelay<String>()
    
    // Outputs
    var scrapPolicies = PublishRelay<[PolicyEntity]>()
    var canceledScrapEntity = PublishRelay<ScrapEntity>()
    
    init(useCase: PolicyUseCase) {
        self.useCase = useCase
        
        fetchScrapPoliciesEvent
            .flatMap { _ in
                
                return useCase.fetchScrapPolicy()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let policyEntities):
                    owner.scrapPolicies.accept(policyEntities)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 스크랩
        updatePolicyScrap
            .withUnretained(self)
            .flatMap { owner, policyID in
                return owner.useCase.updatePolicyScrap(id: policyID)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let scrapEntity):
                    owner.canceledScrapEntity.accept(scrapEntity)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}
