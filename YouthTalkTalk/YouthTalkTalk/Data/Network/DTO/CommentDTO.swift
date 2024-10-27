//
//  CommentDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import Foundation

struct CommentDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: [CommentDetailDTO]
}

struct CommentDetailDTO: Decodable {
    
    let commentId: Int
    let nickname: String
    let content: String
    let isLikedByMember: Bool
    
    func translate() -> CommentDetailEntity {
        
        return CommentDetailEntity(commentId: commentId,
                                   nickname: nickname,
                                   content: content,
                                   isLikedByMember: isLikedByMember)
    }
}
