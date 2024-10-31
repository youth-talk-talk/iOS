//
//  SignInBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/3/24.
//

import Foundation

struct SignInBody: Encodable {
    
    let socialType: String // apple / kakao
    let socialId: String // userIdentifier
    let authorizationCode: String? // apple만
    let identityToken: String? // apple만
    
    init(socialType: SignInType, socialId: String, authorizationCode: String?, identityToken: String?) {
        self.socialType = socialType.rawValue
        self.socialId = socialId
        self.authorizationCode = authorizationCode
        self.identityToken = identityToken
    }
}
