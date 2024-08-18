//
//  RPDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

struct CommunityRPDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: CommunityRPDTOData
}

struct CommunityRPDTOData: Decodable {
    let popularPosts: [RPDTO]
    let recentPosts: [RPDTO]
    
    enum CodingKeys: String, CodingKey {
        case popularPosts = "top5_posts"
        case recentPosts = "other_posts"
    }
}

struct RPDTO: Decodable {
    
    let postID: Int?
    let title: String
    let content: String
    let writerID: Int?
    let scraps: Int
    let scrap: Bool
    let comments: Int
    let policyId: String?
    let policyTitle: String?
    
    func translateEntity() -> RPEntity {
        
        return RPEntity(postID: postID, title: title, content: content, writerID: writerID, scraps: scraps, scrap: scrap, comments: comments, policyId: policyId, policyTitle: policyTitle)
    }
}
