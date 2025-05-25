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
        case popularPosts = "top5Posts"
        case recentPosts = "allPosts"
    }
}

struct RPDTO: Decodable {
    
    let postId: Int?
    let title: String
    let content: String?
    let writerID: Int?
    let scraps: Int?
    let scrap: Bool 
    let comments: Int
    let contentPreview: String?
    let policyId: Int?
    let policyTitle: String?
    let category: String?
    let createAt: String?
}
