//
//  PolicyUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

import RxSwift
import RxCocoa
import KakaoSDKUser

final class PolicyUseCaseImpl: PolicyUseCase {
    
    private let disposeBag = DisposeBag()
    private let policyRepository: PolicyRepository
    
    init(policyRepository: PolicyRepository) {
        self.policyRepository = policyRepository
    }
    
    func fetchHomePolicies(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<HomePolicyEntity, APIError>> {
        
        return policyRepository.fetchHomePolicies(categories: categories, page: page, size: size)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                case .success(let homePolicyDTO):
                    
                    let topFivePolicies = homePolicyDTO.data.topFivePolicies
                        .map { dto in
                            return PolicyEntity(policyId: dto.policyId, category: dto.category, title: dto.title, deadlineStatus: dto.deadlineStatus, hostDep: dto.hostDep, scrap: dto.scrap)
                        }
                    
                    let allPolicies = homePolicyDTO.data.allPolicies
                        .map { dto in
                            return PolicyEntity(policyId: dto.policyId, category: dto.category, title: dto.title, deadlineStatus: dto.deadlineStatus, hostDep: dto.hostDep, scrap: dto.scrap)
                        }
                    
                    let homePolicy = HomePolicyEntity(topFivePolicies: topFivePolicies,
                                                      allPolicies: allPolicies)
                    
                    return .success(homePolicy)
                    
                case .failure(let failure):
                    
                    return .failure(failure)
                }
            }
    }
    
    deinit {
        print("PolicyUseCaseImpl Deinit")
    }
}
