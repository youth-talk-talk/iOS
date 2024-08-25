//
//  PolicyRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxSwift

protocol PolicyRepository {
    
    func fetchHomePolicies(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<HomePolicyDTO, APIError>>
    func fetchConditionPolicies(page:Int, body: PolicyConditionBody) -> Observable<Result<ConditionPolicyDTO, APIError>>
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyDTO, APIError>>
    func updatePolicyScrap(id: String) -> Observable<Result<ScrapDTO, APIError>>
}
