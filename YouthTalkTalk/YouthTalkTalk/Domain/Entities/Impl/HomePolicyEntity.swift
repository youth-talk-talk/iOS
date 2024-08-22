//
//  PolicyEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

struct HomePolicyEntity {
    
    let popularPolicies: [PolicyEntity]
    let recentPolicies: [PolicyEntity]
}

struct PolicyEntity: Hashable {
    
    let uuid = UUID()
    let policyId: String
    let category: String
    let title: String
    let deadlineStatus: String
    let hostDep: String
    var scrap: Bool
    
    static func mockupData() -> PolicyEntity {
        
        return PolicyEntity(policyId: "", category: "", title: "더미 데이터", deadlineStatus: "", hostDep: "", scrap: false)
    }
}
