//
//  APIError.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

enum APIError: Error {
    case success
    case invalidValue
    case methodNotAllowed
    case resourceNotFound
    case serverError
    case unauthorized
    case userNotFound
    case signatureVerificationFailed
    case invalidAppleToken
    case initialSignUpRequired
    case additionalSignUpRequired
    case alreadyJoinedMember
    case invalidAppleUserIdentifier
    case policyNotFound
    case postNotFound
    case insufficientPermissions
    case unknown(String)
    
    init(code: String) {
        switch code {
        case "S01":
            self = .success
        case "F01":
            self = .invalidValue
        case "F02":
            self = .methodNotAllowed
        case "F03":
            self = .resourceNotFound
        case "F04":
            self = .serverError
        case "M01":
            self = .unauthorized
        case "M02":
            self = .userNotFound
        case "M03":
            self = .signatureVerificationFailed
        case "M04":
            self = .invalidAppleToken
        case "M05":
            self = .initialSignUpRequired
        case "M06":
            self = .additionalSignUpRequired
        case "M07":
            self = .alreadyJoinedMember
        case "M08":
            self = .invalidAppleUserIdentifier
        case "PC01":
            self = .policyNotFound
        case "PS01":
            self = .postNotFound
        case "PS02":
            self = .insufficientPermissions
        default:
            self = .unknown(code)
        }
    }
}
