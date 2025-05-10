//
//  SearchViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

final class SearchViewModel {
    private let apiManager = APIManager()
    
    private(set) var filters: [String] = ["정책분야", "지역", "취업상태", "학력", "특화 분야", "연령 및 소득"]
    private(set) var policies: [PolicyDTO] = []
    
    var onError: ((Error) -> Void)?
    
    var onSearched: (() -> Void)?
    
    func requestSearchAPI(_ keyword: String) {
        let param: [String: String] = [
            "page": "0",
            "size": "20"
        ]
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(param: param, body: .init(category: nil,
                                                                                    age: nil,
                                                                                    employmentCodeList: nil,
                                                                                    isFinished: nil,
                                                                                    keyword: keyword)),
                type: SearchPolicyDTO.self)
            switch result {
            case .success(let response):
                policies = response.data.policyList
                
                onSearched?()
            case .failure(let error):
                onError?(error)
            }
        }
    }
}
