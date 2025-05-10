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

    private(set) var categories: [(UIImage, String)] = [(.total, "전체"),
                                                        (.home, "주거"),
                                                        (.education, "교육"),
                                                        (.work, "일자리"),
                                                        (.culture, "복지"),
                                                        (.apply, "참여 권리")]
    
    init() {
        requestPopularPolicyAPI()
    }
    
    func requestPopularPolicyAPI() {
        let body: PolicyConditionBody = .init(categories: nil,
                                              age: nil,
                                              employmentCodeList: nil,
                                              isFinished: nil,
                                              keyword: nil,
                                              sort: "POPULAR")
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(page: 0,
                                                          body: body), // 내 지역 파라미터로 보내기!
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
