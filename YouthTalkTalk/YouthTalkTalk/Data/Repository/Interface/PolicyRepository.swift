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
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyDTO, APIError>>
}
