//
//  SignUpDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/5/24.
//

import Foundation

struct SignUpDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: Double?
}
