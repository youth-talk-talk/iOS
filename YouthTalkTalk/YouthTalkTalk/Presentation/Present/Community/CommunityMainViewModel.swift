//
//  CommunityMainViewModel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/25/25.
//

final class CommunityMainViewModel {
    
    private(set) var freeHotPosts: [RPDTO] = []
    private(set) var freePosts: [RPDTO] = []
    
    private(set) var reviewHotPosts: [RPDTO] = []
    private(set) var reviewPosts: [RPDTO] = []
    
    var onReloaded: (() -> Void)?
    
    func getFreePosts() {
        Task {
            let result = await APIManager().requestAPI(
                router: PostRouter.fetchPost(query: .init(categories: [.all], page: 0, size: 20)),
                type: CommunityRPDTO.self)
            switch result {
            case .success(let response):
                freeHotPosts = response.data.popularPosts
                freePosts = response.data.recentPosts
                onReloaded?()
                
            case .failure: break
            }
        }
    }
    
    func getReviewPosts(selectedCategory: PolicyCategory = .all) {
        Task {
            let result = await APIManager().requestAPI(
                router: ReviewRouter.fetchReview(query: .init(categories: [selectedCategory], page: 0, size: 20)),
                type: CommunityRPDTO.self)
            switch result {
            case .success(let response):
                reviewHotPosts = response.data.popularPosts
                reviewPosts = response.data.recentPosts
                onReloaded?()
                
            case .failure: break
            }
        }
    }
}
