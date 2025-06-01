//
//  PolicyScrapEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/22/24.
//

import Foundation

struct ScrapEntity {
    
    let isScrap: Bool
    let id: Int
    
    init(isScrap: Bool, id: Int) {
        self.isScrap = isScrap
        self.id = id
    }
    
    func isSameID(_ id: Int) -> Bool {
        
        return self.id == id
    }
}

struct LikedComment: Decodable {
    let data: LikedCommentDetail?
}

struct LikedCommentDetail: Decodable {
    let commentCount: Int
    let comments: [LikedCommentData]
}
struct LikedCommentData: Decodable, Hashable {
    let commentId: Int
    let nickname: String
    var content: String
    let policyId: String?
    let articleId: Int?
    let articleType: String
    let articleTitle: String
    let isLikedByMember: Bool
    let likeCount: Int
}
