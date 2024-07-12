//
//  KeyChainRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation

protocol KeyChainRepository {
    
    func saveAppleUserID(saveData: String?, type: AppleKeyChainIdentifierType)
    func saveTokenInfo(saveData: String, type: TokenKeyChainIdentifierType)
    
    func loadAppleUserID(type: AppleKeyChainIdentifierType) -> String
    func loadTokenInfo(type: TokenKeyChainIdentifierType) -> String
    
    func isLogined() -> Bool
}
