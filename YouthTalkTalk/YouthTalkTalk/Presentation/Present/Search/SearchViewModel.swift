//
//  SearchViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

final class SearchViewModel {
    private let apiManager = APIManager()
    
    private(set) var filters: [String] = ["정책분야", "지역", "취업상태", "학력", "특화 분야", "연령 및 소득"]
    
    var onError: ((Error) -> Void)?
    
    var onSearched: (([PolicyDTO]) -> Void)?
    
    func requestSearchAPI(_ keyword: String) {
        let body: PolicyConditionBody = .init(categories: [],
                                              age: nil,
                                              employmentCodeList: [],
                                              isFinished: nil,
                                              keyword: keyword,
                                              sort: nil)
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(page: 0,
                                                          body: body),
                type: SearchPolicyDTO.self)
            switch result {
            case .success(let response):
                onSearched?(response.data.policyList) // TODO: 액세스 토큰 재발급 해보기
            case .failure(let error):
                onError?(error)
            }
        }
    }
}
