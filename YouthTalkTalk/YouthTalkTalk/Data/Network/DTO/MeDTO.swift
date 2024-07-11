//
//  MeDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/10/24.
//

import Foundation

struct MeDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: MeData
}

struct MeData: Decodable {
    
    let nickname: String
    let email: String?
    let region: String
}
