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
    
    func fetchConditionPolicies(page:Int, body: PolicyConditionBody) -> Observable<Result<ConditionPolicyDTO, APIError>> {
        
        let router = PolicyRouter.fetchConditionPolicy(page: page, body: body)
        
        return apiManager.request(router: router, type: ConditionPolicyDTO.self).asObservable()
    }
    
    func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyDTO, APIError>> {
        
        let router = PolicyRouter.fetchPolicyDetail(id: id)
        
        return apiManager.request(router: router, type: DetailPolicyDTO.self).asObservable()
    }
    
    func updatePolicyScrap(id: String) -> Observable<Result<ScrapDTO, APIError>> {
        
        let router = PolicyRouter.updatePolicyScrap(id: id)
        
        return apiManager.request(router: router, type: ScrapDTO.self).asObservable()
    }
    
    func fetchUpComingDeadline() -> Observable<Result<UpcomingScrapDTO, APIError>> {
        
        let router = PolicyRouter.fetchUpComingDeadlineScrap
        
        return apiManager.request(router: router, type: UpcomingScrapDTO.self).asObservable()
    }
    
    func fetchScrapPolicy() -> Observable<Result<ScrapPolicyDTO, APIError>> {
        
        let router = PolicyRouter.fetchScrapPolicy
        
        return apiManager.request(router: router, type: ScrapPolicyDTO.self).asObservable()
    }  
    
    func uploadImage(_ image: Data) -> Observable<Result<String, APIError>> {
        
        return apiManager.postUploadImage(stringURL: "/posts/image", image: image).asObservable()
    }
    
    
    func uploadPost(_ body: UploadPostBody) -> Observable<Result<UploadPostDTO, APIError>> {
        
        let router = PolicyRouter.uploadPost(body: body)
        
        return apiManager.request(router: router, type: UploadPostDTO.self).asObservable()
    }
}
