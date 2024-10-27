//
//  DetailRPDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation

struct DetailRPDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: DetailRPDetailDTO
}

struct DetailRPDetailDTO: Decodable {
    
    let postId: Int
    let postType: String
    let title: String
    let content: String
    let contentList: [DetailContentDTO]
    let policyId: String?
    let policyTitle: String?
    let writerId: Int
    let nickname: String?
    let view: Int
    let images: [String]
    let category: String?
    let scrap: Bool
    
    func translate() -> DetailRPEntity {
        
        return DetailRPEntity(postId: postId, postType: postType, title: title, content: content,
                              contentList: contentList.map { $0.translate() }, policyId: policyId, policyTitle: policyTitle,
                              writerId: writerId, nickname: nickname, view: view, images: images, category: category,
                              scrap: scrap)
    }
}

struct DetailContentDTO: Decodable {
    
    let content: String
    let type: String
    
    func translate() -> DetailContentEntity {
        return DetailContentEntity(content: content, type: type)
    }
}
