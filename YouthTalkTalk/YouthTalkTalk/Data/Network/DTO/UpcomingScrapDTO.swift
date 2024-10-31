//
//  UpcomingScrapDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import Foundation

struct UpcomingScrapDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: [PolicyDTO]
}
