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
    let data: MeDataDTO
}

struct MeDataDTO: Decodable {
    
    let nickname: String
    let email: String?
    let profileImgUrl: String?
    let region: String
}

struct DeleteAccountDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: Data?
}

struct PatchMeDTO: Decodable {
    let status: Int
    let message: String
    let code: String
    let data: PatchMeDataDTO
}

struct PatchMeDataDTO: Decodable {
    let memberId: Int
    let nickname: String
    let region: String
}
