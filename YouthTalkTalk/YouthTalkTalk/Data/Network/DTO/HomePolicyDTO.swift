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


struct HomePolicyDataDTO: Decodable {
    
    let popularPolicies: [PolicyDTO]
    let recentPolicies: [PolicyDTO]
    
    enum CodingKeys: String, CodingKey {
        case popularPolicies = "top5Policies"
        case recentPolicies = "allPolicies"
    }
}

struct PolicyDTO: Decodable {
    
    let policyId: String
    let category: String
    let title: String
    let deadlineStatus: String
    let hostDep: String
    let scrap: Bool
}

