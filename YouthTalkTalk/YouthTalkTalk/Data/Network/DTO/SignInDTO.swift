//
//  SignInDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation

struct SignInDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: SignInData
}

struct SignInData: Decodable {
    
    let memberId: Int
}
