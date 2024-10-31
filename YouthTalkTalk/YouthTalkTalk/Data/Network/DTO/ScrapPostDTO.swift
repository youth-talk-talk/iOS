//
//  ScrapPostDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation

struct ScrapPostDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: [RPDTO]
}