//
//  PolicyUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol PolicyUseCase {
    
    func fetchHomePolicies(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<HomePolicyEntity, APIError>>
    func fetchConditionPolicies(page:Int, body: PolicyConditionBody) -> Observable<Result<([PolicyEntity], Int), APIError>>
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyEntity, APIError>>
    func updatePolicyScrap(id: String) -> Observable<Result<ScrapEntity, APIError>>
    func fetchUpComingDeadline() -> Observable<Result<[PolicyEntity], APIError>>
    func fetchScrapPolicy() -> Observable<Result<[PolicyEntity], APIError>>
}
