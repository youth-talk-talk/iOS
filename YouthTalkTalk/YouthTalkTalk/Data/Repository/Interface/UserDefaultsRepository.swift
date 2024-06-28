//
//  UserDefaultsRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation

protocol UserDefaultsRepository {
    
    func saveSignedInState(signedInType: SignInType)
    func isSignedIn() -> SignInType
}
