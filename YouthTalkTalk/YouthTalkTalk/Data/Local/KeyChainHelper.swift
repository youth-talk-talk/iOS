//
//  KeyChainHelper.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import Foundation
import Security

enum AppleKeyChainIdentifierType: String {
    
    case appleIdentifier
    case appleIdentifierToken
    case authorizationCode
}

enum TokenKeyChainIdentifierType: String {
    
    case accessToken
    case refreshToken
}

final class KeyChainHelper {
    
    /// 저장 - 애플 정보 저장
    func saveAppleInfo(saveData: String?, type: AppleKeyChainIdentifierType) {
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
    
    /// 불러오기 - 애플 토큰 정보 불러오기
    func loadAppleInfo(type: AppleKeyChainIdentifierType) -> String {
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
            return ""
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// 저장 - 엑세스 토큰, 리프레쉬 토큰 중 저장
    func saveTokenInfo(saveData: String, type: TokenKeyChainIdentifierType) {
        let keychainIdentifier = type.rawValue
    
        // Keychain에 저장할 데이터 준비
        guard let data = saveData.data(using: .utf8) else { return }
        
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
    
    /// 불러오기 - 엑세스 토큰, 리프레쉬 토큰 불러오기
    func loadTokenInfo(type: TokenKeyChainIdentifierType) -> String {
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
            return ""
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// 저장 - 엑세스 토큰, 리프레쉬 토큰 한번에 저장
    func saveTokenInfoFromHttpResponse(response: HTTPURLResponse) {
     
        if let accessToken = response.value(forHTTPHeaderField: "Authorization") {
            self.saveTokenInfo(saveData: accessToken, type: .accessToken)
        }
        
        if let refreshToken = response.value(forHTTPHeaderField: "Authorization-refresh") {
            self.saveTokenInfo(saveData: refreshToken, type: .refreshToken)
        }
    }
    
    /// 삭제 - 엑세스 토큰, 리프레쉬 토큰 삭제
    func deleteTokenInfo(type: TokenKeyChainIdentifierType) {
            let keychainIdentifier = type.rawValue
            
            // Keychain Query 설정
            let query: NSDictionary = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: keychainIdentifier
            ]
            
            // 키체인에서 아이템 삭제 시도
            let status = SecItemDelete(query)
            
            if status == errSecSuccess {
                print("\(type.rawValue) 삭제 성공")
            } else {
                print("\(type.rawValue) 삭제 실패, 상태 코드: \(status)")
            }
        }
    
    func isLogined() -> Bool {
        
        let accessToken = loadTokenInfo(type: .accessToken)
        
        if accessToken == "" {
            return false
        }
        
        return true
    }
}
