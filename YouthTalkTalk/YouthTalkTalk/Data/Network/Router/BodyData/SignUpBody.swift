//
//  SignUpBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/5/24.
//

import Foundation

struct SignUpBody: Encodable {
    
    let socialType: String // kakao / apple
    let socialId: String // userIdentifier
    let nickname: String
    let region: String
    let idToken: String?
    
    // init(username: String, nickname: String, region: String, idToken: String?, signInType: SignInType) {
    //     self.username = signInType.rawValue + username
    //     self.nickname = nickname
    //     self.region = region
    //     self.idToken = idToken
    // }
    
    init(socialType: SignInType, socialId: String, nickname: String, region: String, idToken: String?) {
        self.socialType = socialType.rawValue
        self.socialId = socialId
        self.nickname = nickname
        self.region = region
        self.idToken = idToken
    }
}
