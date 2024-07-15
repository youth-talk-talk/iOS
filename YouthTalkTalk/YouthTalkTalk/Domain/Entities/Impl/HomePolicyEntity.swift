//
//  PolicyEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

struct HomePolicyEntity {
    
    let topFivePolicies: [PolicyEntity]
    let allPolicies: [PolicyEntity]
}

struct PolicyEntity {
    
    let policyId: String
    let category: String
    let title: String
    let deadlineStatus: String
    let hostDep: String
    let scrap: Bool
}
