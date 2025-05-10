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

    private(set) var categories: [(UIImage, String)] = [(.total, "전체"),
                                                        (.home, "주거"),
                                                        (.education, "교육"),
                                                        (.work, "일자리"),
                                                        (.culture, "복지"),
                                                        (.apply, "참여 권리")]
    
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
        let body: PolicyConditionBody = .init(categories: nil,
                                              age: nil,
                                              employmentCodeList: nil,
                                              isFinished: nil,
                                              keyword: nil,
                                              sort: nil)
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(page: 0,
                                                          body: body,
                                                          region: myRegion),
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
