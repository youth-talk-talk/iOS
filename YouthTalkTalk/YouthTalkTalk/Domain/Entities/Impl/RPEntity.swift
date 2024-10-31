//
//  RPEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

struct CommunityRPEntity {
    
    let popularRP: [RPEntity]
    let recentRP: [RPEntity]
}

struct RPEntity: Hashable {
    
    let uuid = UUID()
    let postId: Int?
    let title: String
    let content: String
    let writerID: Int?
    let scraps: Int
    let scrap: Bool
    let comments: Int
    let policyId: String?
    let policyTitle: String?
    
    static func mockupData() -> RPEntity {
        
        return RPEntity(postId: 0, title: "mockUp", content: "mockUp", writerID: 0, scraps: 0, scrap: false, comments: 0, policyId: nil, policyTitle: nil)
    }
}
