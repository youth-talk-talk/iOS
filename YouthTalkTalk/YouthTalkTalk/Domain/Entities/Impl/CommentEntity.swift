//
//  CommentEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation

struct CommentEntity {
    
    let status: Int
    let message: String
    let code: String
    let data: [CommentDetailDTO]
}

struct CommentDetailEntity: Hashable {
    
    let commentId: Int
    let nickname: String
    let content: String
    let isLikedByMember: Bool
}
