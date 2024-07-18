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
        
        let homePolicy = HomePolicyBody(categories: categories, page: page, size: size)
        let router = PolicyRouter.fetchHomePolicy(homePolicy: homePolicy)
        
        return apiManager.request(router: router, type: HomePolicyDTO.self).asObservable()
    }
    
    deinit {
        print("PolicyRepositoryImpl Deinit")
    }
}
