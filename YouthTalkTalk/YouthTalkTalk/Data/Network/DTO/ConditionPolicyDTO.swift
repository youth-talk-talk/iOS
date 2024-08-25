//
//  ConditionPolicyDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/25/24.
//

import Foundation

struct ConditionPolicyDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: [PolicyDTO]
}
