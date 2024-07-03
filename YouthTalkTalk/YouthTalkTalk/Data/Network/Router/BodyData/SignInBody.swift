//
//  SignInBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation

struct SignInBody: Encodable {
    
    let username: String // userIdentifier
    let authorizationCode: String? // apple만
    
    init(username: String, authorizationCode: String?, signInType: SignInType) {
        self.username = signInType.rawValue + username
        self.authorizationCode = authorizationCode
    }
}
