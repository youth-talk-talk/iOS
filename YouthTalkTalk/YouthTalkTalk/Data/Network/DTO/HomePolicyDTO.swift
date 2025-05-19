//
//  HomePolicyDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

struct HomePolicyDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: HomePolicyDataDTO
}

struct SearchPolicyDTO: Decodable {
    let status: Int
    let message: String
    let code: String
    let data: SearchPolicyDataDTO
}

struct SearchPolicyDataDTO: Decodable {
    let totalCount: Int
    let policyList: [PolicyDTO]
}


struct HomePolicyDataDTO: Decodable {
    let popularPolicies: [PolicyDTO]
    let policiesWithReviews: [PolicyWithReviewsDTO]
    let bestPosts: [BestPostDTO]
}

struct PolicyDTO: Decodable, Equatable {
    let policyId: Int
    let category: String
    let title: String
    let deadlineStatus: String
    let hostDep: String
    let scrap: Bool
    let scrapCount: Int
    var region: String?
    let departmentImgUrl: String?
}

struct NewPolicyDTO: Decodable {
    let status: Int
    let message: String
    let code: String
    let data: [String: [PolicyDTO]]
}

struct PolicyWithReviewsDTO: Decodable {
    let policyId: Int
    let title: String
    let departmentImgUrl: String?
    let reviews: [ReviewDTO]
}

struct ReviewDTO: Decodable {
    let postId: Int
    let title: String
    let contentPreview: String
    let commentCount: Int
    let scrapCount: Int
    let scrap: Bool
    let createdAt: String
}

struct BestPostDTO: Decodable {
    let postId: Int
    let title: String
    let writerId: Int
    let policyId: Int?
    let policyTitle: String?
    let comments: Int
    let contentPreview: String
    let scraps: Int?
    let scrap: Bool
    let createdAt: String
}
