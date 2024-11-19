//
//  MyPageViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: MyPageInterface {
    
    private var disposeBag = DisposeBag()
    private var useCase: PolicyUseCase
    private var memberUseCase: MemberUseCase
    
    var input: MyPageInput { return self }
    var output: MyPageOutput { return self }
    
    // Inputs
    var fetchMe = PublishRelay<Void>()
    var fetchUpcomingScrapEvent = PublishRelay<Void>()
    var updatePolicyScrap = PublishRelay<String>()
    var deleteAccount = PublishRelay<Void>()
    
    // Outputs
    var upcomingScrapPolicies = PublishRelay<[PolicyEntity]>()
    var canceledScrapEntity = PublishRelay<ScrapEntity>()
    var meEntity = PublishRelay<MeEntity>()
    var successDeleteAccount = PublishRelay<Void>()
    
    init(useCase: PolicyUseCase, memberUseCase: MemberUseCase) {
        self.useCase = useCase
        self.memberUseCase = memberUseCase
        
        fetchMe
            .flatMap { _ in
                return memberUseCase.fetchMe()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let meEntity):
                    owner.meEntity.accept(meEntity)
                case .failure(let error):
                    break
                }
            }
            .disposed(by: disposeBag)
        
        deleteAccount
            .flatMap { _ in
                memberUseCase.deleteAccount()
            }
            .bind(with: self) { [weak self] owner, isSuccess in
                if isSuccess {
                    self?.successDeleteAccount.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        fetchUpcomingScrapEvent
            .flatMap { _ in
                
                return useCase.fetchUpComingDeadline()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let upcomingPolicyEntities):
                    owner.upcomingScrapPolicies.accept(upcomingPolicyEntities)
                case .failure(let error):
                    break
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
                    break
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}
