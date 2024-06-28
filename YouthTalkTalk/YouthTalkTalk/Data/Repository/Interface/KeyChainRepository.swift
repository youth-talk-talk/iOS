//
//  KeyChainRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation

protocol KeyChainRepository {
    
    func saveAppleUserID(saveData: String?, type: keyChainIdentifierType)
    func loadAppleUserID(type: keyChainIdentifierType) -> String
}
