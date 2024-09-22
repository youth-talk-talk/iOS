//
//  ConditionReviewDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/22/24.
//

import Foundation

struct ConditionReviewDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: ConditionReviewDetailDTO
}

struct ConditionReviewDetailDTO: Decodable {
    
    let total: Int
    let page: Int
    let posts: [RPDTO]
}
