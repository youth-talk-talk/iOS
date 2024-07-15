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
    
    var fetchPolicies = PublishRelay<Void>()
    
    init(policyUseCase: PolicyUseCase) {
        self.policyUseCase = policyUseCase
        
        fetchPolicies
            .flatMap { _ in
                
                return policyUseCase.fetchHomePolicies(categories: [.job, .life], page: 1, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let homePolicyEntity):
                    
                    dump(homePolicyEntity)
                    
                case .failure(let error):
                    
                    print("실패")
                }
            }.disposed(by: disposeBag)
    }
}
