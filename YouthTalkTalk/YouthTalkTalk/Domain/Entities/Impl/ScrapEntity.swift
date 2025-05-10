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
    let status: Int
    let message, code: String
    let data: [LikedCommentData]
}

struct LikedCommentData: Decodable, Hashable {
    let commentId: Int
    let nickname: String
    var content: String
    let policyId: String?
    let postID: Int?
}
