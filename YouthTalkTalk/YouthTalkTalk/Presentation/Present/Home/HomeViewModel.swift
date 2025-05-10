//
//  HomeViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//
//

import UIKit

final class HomeViewModel {
    private let apiManager = APIManager()
    
    var onError: ((Error) -> Void)?
    var onReloadData: (() -> Void)?
    
    private(set) var allPopularPolicies: [PolicyDTO] = []
    private(set) var popularPolicies: [PolicyDTO] = []
    private(set) var myRegion: String = ""

    private(set) var categories: [(UIImage, PolicyCategory)] = [(.total, .all),
                                                                (.home, .dwelling),
                                                                (.education, .education),
                                                                (.work, .job),
                                                                (.culture, .life),
                                                                (.apply, .participation)]
    
    init() {
        requestMyInfoAPI()
    }
    
    private func requestMyInfoAPI() {
        Task {
            let result = await apiManager.requestAPI(
                router: MeRouter.patchMe(.init(nickname: nil, region: nil)),
                type: PatchMeDTO.self)
            switch result {
            case .success(let response):
                myRegion = response.data.region
                
                requestPopularPolicyAPI()
                
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    private func requestPopularPolicyAPI() {
        let param: [String: String] = [
            "page": "0",
            "size": "20",
            "sort": "POPULAR"
        ]
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(param: param, body: nil),
                type: SearchPolicyDTO.self)
            switch result {
            case .success(let response):
                allPopularPolicies = response.data.policyList
                popularPolicies = Array(response.data.policyList.prefix(10))
                onReloadData?()
                
            case .failure(let error):
                onError?(error)
            }
        }
    }
}
