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
    private(set) var newAllPolicies: [String: [PolicyDTO]] = [:]
    private(set) var newPolicies: [PolicyDTO] = []
    private(set) var policiesWithReviews: [PolicyWithReviewsDTO] = []
    private(set) var bestPosts: [BestPostDTO] = []
    private(set) var myRegion: String = ""

    private(set) var categories: [(UIImage, PolicyCategory)] = [(.total, .all),
                                                                (.home, .dwelling),
                                                                (.education, .education),
                                                                (.work, .job),
                                                                (.culture, .life),
                                                                (.apply, .participation)]
    
    init() {
        requestMyInfoAPI { _ in }
        getNewPolicies()
        getHomePolicies()
    }
    
    func requestMyInfoAPI(onCompleted: @escaping (String) -> Void) {
        Task {
            let result = await apiManager.requestAPI(
                router: MeRouter.patchMe(.init(nickname: nil, region: nil)),
                type: PatchMeDTO.self)
            switch result {
            case .success(let response):
                myRegion = response.data.region
                
                onCompleted(myRegion)
                
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    private func getNewPolicies() {
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.newPolicies,
                type: NewPolicyDTO.self)
            switch result {
            case .success(let response):
                newAllPolicies = response.data
                newPolicies = response.data["ALL"] ?? []
                onReloadData?()
                
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    func setNewPoliciesByCategory(category: String) {
        newPolicies = newAllPolicies[category] ?? newPolicies
        onReloadData?()
    }
    
    private func getHomePolicies() {
        Task {
            let result = await apiManager.requestAPI(
                router: PolicyRouter.homePolicies,
                type: HomePolicyDTO.self)
            switch result {
            case .success(let response):
                allPopularPolicies = response.data.popularPolicies
                popularPolicies = Array(response.data.popularPolicies.prefix(10))
                policiesWithReviews = response.data.policiesWithReviews
                bestPosts = response.data.bestPosts
                
                onReloadData?()
                
            case .failure(let error):
                onError?(error)
            }
        }
    }
}
