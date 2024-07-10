//
//  KeyChainRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation

final class KeyChainRepositoryImpl: KeyChainRepository {
    
    private let keyChainHelper = KeyChainHelper()
    
    // MARK: APPLE IDENTIFIER
    func saveAppleUserID(saveData: String?, type: AppleKeyChainIdentifierType) {
    
        keyChainHelper.saveAppleInfo(saveData: saveData, type: type)
    }
    
    func loadAppleUserID(type: AppleKeyChainIdentifierType) -> String {
    
        keyChainHelper.loadAppleInfo(type: type) ?? ""
    }
    
    func isLogined() -> Bool {
        
        let accessToken = keyChainHelper.loadTokenInfo(type: .accessToken)
        
        if accessToken == "" {
            return false
        }
        
        return true
    }
}
