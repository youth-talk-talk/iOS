//
//  PolicyCollectionViewModel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/10/25.
//

import UIKit

final class PolicyCollectionViewModel {
    private let apiManager = APIManager()
    
    private(set) var selectedCategory: PolicyCategory
    
    private(set) var categories: [(UIImage, PolicyCategory)] = [(.total, .all),
                                                                (.home, .dwelling),
                                                                (.education, .education),
                                                                (.work, .job),
                                                                (.culture, .life),
                                                                (.apply, .participation)]
    
    private(set) var filters: [String] = ["정책분야", "지역", "취업상태", "학력", "특화 분야", "연령 및 소득"]
    
    private(set) var policies: [PolicyDTO] = []
    
    var onReloadData: (() -> Void)?

    init(selectedCategory: PolicyCategory) {
        self.selectedCategory = selectedCategory
        
        requestPolicies()
    }
    
    func didTapCategory(index: Int) {
        selectedCategory = categories[index].1
        requestPolicies()
    }
    
    private func requestPolicies() {
        let param: [String: String] = [
            "page": "0",
            "size": "20"
        ]
        
        let category = selectedCategory.rawValue == "" ? nil : [selectedCategory.rawValue]
        
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.fetchConditionPolicy(param: param, body: .init(category: category,
                                                                                    age: nil,
                                                                                    employmentCodeList: nil,
                                                                                    isFinished: nil,
                                                                                    keyword: nil)),
                type: SearchPolicyDTO.self)
            switch result {
            case .success(let response):
                policies = response.data.policyList
                onReloadData?()
                
            case .failure(let error):
                break
            }
        }
    }
}
