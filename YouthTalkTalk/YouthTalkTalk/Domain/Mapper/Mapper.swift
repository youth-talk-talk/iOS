//
//  Mapper.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation

struct Mapper {
    
    private init() { }
    
    static func mapSingIn(dto: SignInDTO) -> SignInEntity {
        
        return SignInEntity(status: dto.status,
                                message: dto.message,
                                code: dto.code,
                                memberId: dto.data.memberId)
    }
}
