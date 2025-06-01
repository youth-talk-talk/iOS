//
//  PolicyMainViewModel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import Foundation

final class PolicyMainViewModel {
    private(set) var seePolicies: [PolicyDTO] = []
    private(set) var endPolicies: [PolicyDTO] = []
    private(set) var allPolicies: [PolicyDTO] = []
    
    var date: [(String, Int)] {
        let calendar = Calendar.current
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        
        var result: [(String, Int)] = []

        for i in 0..<7 {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: today) {
                let weekday = i == 0 ? "오늘" : dateFormatter.string(from: nextDate)
                let day = calendar.component(.day, from: nextDate)
                result.append((weekday, day))
            }
        }

        return result
    }
    
    var selectedCategory: PolicyCategory = .all {
        didSet {
            getAllPolicy()
        }
    }
    
    var onReloaded: (() -> Void)?
    
    func requestMyInfoAPI(onCompleted: @escaping (String) -> Void) {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.patchMe(.init(nickname: nil, region: nil)),
                type: PatchMeDTO.self)
            switch result {
            case .success(let response):
                onCompleted(response.data.region)
                
            case .failure:
                break
            }
        }
    }
    
    func getSeePolicies() {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.seePolicies,
                type: ScrapPolicyDTO.self)
            switch result {
            case .success(let response):
                seePolicies = response.data
                onReloaded?()
                
            case .failure:
                break
            }
        }
    }
    
    func getEndPolicies() {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.endPolicies,
                type: ScrapPolicyDTO.self)
            switch result {
            case .success(let response):
                endPolicies = response.data
                onReloaded?()
                
            case .failure:
                break
            }
        }
    }
    
    func getAllPolicy() {
        let param: [String: String] = [
            "page": "0",
            "size": "20"
        ]
        
        let category = selectedCategory.rawValue == "" ? nil : [selectedCategory.rawValue]

        Task {
            let result = await APIManager().requestAPI(
                router: PolicyRouter.fetchConditionPolicy(param: param, body: .init(category: category,
                                                                                    age: nil,
                                                                                    employmentCodeList: nil,
                                                                                    isFinished: nil,
                                                                                    keyword: nil)),
                type: SearchPolicyDTO.self)
            switch result {
            case .success(let response):
                allPolicies = response.data.policyList
                onReloaded?()
                
            case .failure:
                break
            }
        }
    }
}
