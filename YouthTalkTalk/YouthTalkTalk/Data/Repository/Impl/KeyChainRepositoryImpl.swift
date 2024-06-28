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
    func saveAppleUserID(saveData: String?, type: keyChainIdentifierType) {
    
        keyChainHelper.saveAppleInfo(saveData: saveData, type: type)
    }
    
    func loadAppleUserID(type: keyChainIdentifierType) -> String {
    
        keyChainHelper.loadAppleInfo(type: type) ?? ""
    }
}
