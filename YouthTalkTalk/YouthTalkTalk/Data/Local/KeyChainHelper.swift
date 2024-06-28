//
//  KeyChainHelper.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation
import Security

enum keyChainIdentifierType: String {
    
    case appleIdentifier
    case appleIdentifierToken
    case authorizationCode
}

final class KeyChainHelper {
    
    func saveAppleInfo(saveData: String?, type: keyChainIdentifierType) {
        let keychainIdentifier = type.rawValue

        // Keychain에 저장할 데이터 준비
        guard let data = saveData?.data(using: .utf8) else { return }
        
        // Keychain Query 설정
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainIdentifier,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        // 기존 데이터가 있는 경우 업데이트, 없는 경우 추가
        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)

        if status != errSecSuccess {
            // 추가 또는 업데이트 실패 시, 새로운 아이템 추가 시도
            SecItemAdd(query, nil)
        }
    }
    
    func loadAppleInfo(type: keyChainIdentifierType) -> String? {
        let keychainIdentifier = type.rawValue

        // Keychain Query 설정
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keychainIdentifier,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
