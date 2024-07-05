//
//  SignUpBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/5/24.
//

import Foundation

struct SignUpBody: Encodable {
    
    let username: String // userIdentifier
    let nickname: String
    let region: String
    let idToken: String?
    
    init(username: String, nickname: String, region: String, idToken: String?, signInType: SignInType) {
        self.username = signInType.rawValue + username
        self.nickname = nickname
        self.region = region
        self.idToken = idToken
    }
}
