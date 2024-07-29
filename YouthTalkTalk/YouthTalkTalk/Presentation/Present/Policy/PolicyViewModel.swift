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
    
    var fetchPolicyDetail = PublishRelay<String>()
    
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
                    
                    dump(policyDetailEntity)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
