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
                    
                    let popularPolicies = homePolicyDTO.data.popularPolicies
                        .map { dto in
                            return PolicyEntity(policyId: dto.policyId, category: dto.category, title: dto.title, deadlineStatus: dto.deadlineStatus, hostDep: dto.hostDep, scrap: dto.scrap)
                        }
                    
                    let recentPolicies = homePolicyDTO.data.recentPolicies
                        .map { dto in
                            return PolicyEntity(policyId: dto.policyId, category: dto.category, title: dto.title, deadlineStatus: dto.deadlineStatus, hostDep: dto.hostDep, scrap: dto.scrap)
                        }
                    
                    let homePolicy = HomePolicyEntity(popularPolicies: popularPolicies,
                                                      recentPolicies: recentPolicies)
                    
                    return .success(homePolicy)
                    
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
    
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyEntity, APIError>> {
        
        return policyRepository.fetchPolicyDetail(id: id)
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                    
                case .success(let detailPolicyDTO):
                
                    let detailPolicyEntity = detailPolicyDTO.data.translateDetailPolicyEntity()
                    
                    return .success(detailPolicyEntity)
                case .failure(let error):
                    
                    return .failure(error)
                    
                }
            }
        
    }
    
    deinit {
        print("PolicyUseCaseImpl Deinit")
    }
}
