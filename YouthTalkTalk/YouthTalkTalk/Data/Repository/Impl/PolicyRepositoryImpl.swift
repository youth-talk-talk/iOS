//
//  PolicyRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PolicyRepositoryImpl: PolicyRepository {
    
    private let disposeBag = DisposeBag()
    private let apiManager = APIManager()
    
    
    func fetchHomePolicies(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<HomePolicyDTO, APIError>> {
        
        let homePolicy = PolicyQuery(categories: categories, page: page, size: size)
        let router = PolicyRouter.fetchHomePolicy(policy: homePolicy)
        
        return apiManager.request(router: router, type: HomePolicyDTO.self).asObservable()
    }
    
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyDTO, APIError>> {
        
        let router = PolicyRouter.fetchPolicyDetail(id: id)
        
        return apiManager.request(router: router, type: DetailPolicyDTO.self).asObservable()
    }
    
    deinit {
        print("PolicyRepositoryImpl Deinit")
    }
}
