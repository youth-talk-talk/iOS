//
//  DetailRPEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation

struct DetailRPEntity {
    
    let postId: Int
    let postType: String
    let title: String
    let content: String
    let contentList: [DetailContentEntity]
    let policyId: String?
    let policyTitle: String?
    let writerId: Int
    let nickname: String?
    let view: Int
    let images: [String]
    let category: String?
    let scrap: Bool
}
