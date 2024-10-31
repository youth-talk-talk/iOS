//
//  APIError.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

import Foundation

enum APIError: Error {
    // Success Cases
    case success                     // 요청에 성공하였습니다.
    case scrapSuccess                // 스크랩에 성공하였습니다.
    case scrapCancelSuccess          // 스크랩을 취소하였습니다.
    case policyFetchSuccess          // 정책 조회에 성공하였습니다.
    case noPolicyResults             // 조건에 맞는 정책 결과가 없습니다.
    case commentRegisterSuccess      // 댓글을 성공적으로 등록했습니다.
    case commentUpdateSuccess        // 댓글을 성공적으로 수정했습니다.
    case commentDeleteSuccess        // 댓글을 성공적으로 삭제했습니다.
    case noUserComments              // 회원이 작성한 댓글이 없습니다.
    case likeRegisterSuccess         // 좋아요 등록이 완료되었습니다.
    case likeCancelSuccess           // 좋아요 해제가 완료되었습니다.
    case userInfoUpdateSuccess       // 회원정보 수정을 완료하였습니다.
    case userWithdrawalSuccess       // 회원 탈퇴를 완료하였습니다.
    
    // Failure Cases
    case invalidInput                // 유효하지 않은 값을 입력하였습니다.
    case methodNotAllowed            // 허용되지 않는 메서드입니다.
    case resourceNotFound            // 리소스를 찾을 수 없습니다.
    case serverError                 // 예기치 못한 서버 에러가 발생했습니다.
    
    // Member Cases
    case notMember                   // 회원이 아닙니다.
    case userNotFound                // 사용자를 찾을 수 없습니다.
    case appleKeyVerificationFailed  // 애플 공개키를 이용한 서명 검증에 실패했습니다.
    case invalidAppleToken           // 애플 토큰이 유효하지 않습니다.
    case appleSignUpRequired         // 애플 최초 회원가입이 필요합니다.
    case appleAdditionalSignUpRequired // 애플 추가 회원가입이 필요합니다.
    case alreadyRegisteredUser       // 이미 가입한 회원입니다.
    case invalidAppleUserIdentifier  // 애플 USERIDENTIFIER가 유효하지 않습니다.
    case invalidAccessToken          // 유효하지 않은 엑세스 토큰입니다.
    case invalidRefreshToken         // 유효하지 않은 리프레시 토큰입니다.
    
    // Policy Cases
    case policyNotFound              // 해당 정책을 찾을 수 없습니다.
    
    // Post Cases
    case postNotFound                // 해당 게시글을 찾을 수 없습니다.
    case postNoPermission            // 해당 게시글에 대한 권한이 없습니다.
    
    // Comment Cases
    case commentNotFound             // 해당 댓글을 찾을 수 없습니다.
    case alreadyLikedComment         // 이미 좋아요한 댓글입니다.
    case likeInfoNotFound            // 좋아요 정보가 없습니다.
    
    case unknown                     // 알 수 없는 에러입니다.
    
    init(code: String) {
        switch code {
        case "S01":
            self = .success
        case "S02":
            self = .scrapSuccess
        case "S03":
            self = .scrapCancelSuccess
        case "S04":
            self = .policyFetchSuccess
        case "S05":
            self = .noPolicyResults
        case "S06":
            self = .commentRegisterSuccess
        case "S07":
            self = .commentUpdateSuccess
        case "S08":
            self = .commentDeleteSuccess
        case "S09":
            self = .noUserComments
        case "S10":
            self = .likeRegisterSuccess
        case "S11":
            self = .likeCancelSuccess
        case "S12":
            self = .userInfoUpdateSuccess
        case "S13":
            self = .userWithdrawalSuccess

        case "F01":
            self = .invalidInput
        case "F02":
            self = .methodNotAllowed
        case "F03":
            self = .resourceNotFound
        case "F04":
            self = .serverError

        case "M01":
            self = .notMember
        case "M02":
            self = .userNotFound
        case "M03":
            self = .appleKeyVerificationFailed
        case "M04":
            self = .invalidAppleToken
        case "M05":
            self = .appleSignUpRequired
        case "M06":
            self = .appleAdditionalSignUpRequired
        case "M07":
            self = .alreadyRegisteredUser
        case "M08":
            self = .invalidAppleUserIdentifier

        case "PC01":
            self = .policyNotFound

        case "PS01":
            self = .postNotFound
        case "PS02":
            self = .postNoPermission

        case "C01":
            self = .commentNotFound
        case "C02":
            self = .alreadyLikedComment
        case "C03":
            self = .likeInfoNotFound
            
        case "T01":
            self = .invalidAccessToken
        case "T02":
            self = .invalidRefreshToken

        default:
            self = .unknown
        }
    }

    
    // Associated Message
    var msg: String {
        switch self {
        case .success: return "요청에 성공하였습니다."
        case .scrapSuccess: return "스크랩에 성공하였습니다."
        case .scrapCancelSuccess: return "스크랩을 취소하였습니다."
        case .policyFetchSuccess: return "정책 조회에 성공하였습니다."
        case .noPolicyResults: return "조건에 맞는 정책 결과가 없습니다."
        case .commentRegisterSuccess: return "댓글을 성공적으로 등록했습니다."
        case .commentUpdateSuccess: return "댓글을 성공적으로 수정했습니다."
        case .commentDeleteSuccess: return "댓글을 성공적으로 삭제했습니다."
        case .noUserComments: return "회원이 작성한 댓글이 없습니다."
        case .likeRegisterSuccess: return "좋아요 등록이 완료되었습니다."
        case .likeCancelSuccess: return "좋아요 해제가 완료되었습니다."
        case .userInfoUpdateSuccess: return "회원정보 수정을 완료하였습니다."
        case .userWithdrawalSuccess: return "회원 탈퇴를 완료하였습니다."
            
        case .invalidInput: return "유효하지 않은 값을 입력하였습니다."
        case .methodNotAllowed: return "허용되지 않는 메서드입니다."
        case .resourceNotFound: return "리소스를 찾을 수 없습니다."
        case .serverError: return "예기치 못한 서버 에러가 발생했습니다."
            
        case .notMember: return "회원이 아닙니다."
        case .userNotFound: return "사용자를 찾을 수 없습니다."
        case .appleKeyVerificationFailed: return "애플 공개키를 이용한 서명 검증에 실패했습니다."
        case .invalidAppleToken: return "애플 토큰이 유효하지 않습니다."
        case .appleSignUpRequired: return "애플 최초 회원가입이 필요합니다."
        case .appleAdditionalSignUpRequired: return "애플 추가 회원가입이 필요합니다."
        case .alreadyRegisteredUser: return "이미 가입한 회원입니다."
        case .invalidAppleUserIdentifier: return "애플 USERIDENTIFIER가 유효하지 않습니다."
        case .invalidAccessToken: return "유효하지 않은 엑세스 토큰입니다."
        case .invalidRefreshToken: return "유효하지 않은 리프레시 토큰입니다."
            
        case .policyNotFound: return "해당 정책을 찾을 수 없습니다."
            
        case .postNotFound: return "해당 게시글을 찾을 수 없습니다."
        case .postNoPermission: return "해당 게시글에 대한 권한이 없습니다."
            
        case .commentNotFound: return "해당 댓글을 찾을 수 없습니다."
        case .alreadyLikedComment: return "이미 좋아요한 댓글입니다."
        case .likeInfoNotFound: return "좋아요 정보가 없습니다."
        case .unknown: return "알 수 없는 에러입니다."
        }
    }
    
    var isSuccess: Bool {
            switch self {
            case .success, .scrapSuccess, .scrapCancelSuccess, .policyFetchSuccess,
                 .noPolicyResults, .commentRegisterSuccess, .commentUpdateSuccess,
                 .commentDeleteSuccess, .noUserComments, .likeRegisterSuccess,
                 .likeCancelSuccess, .userInfoUpdateSuccess, .userWithdrawalSuccess:
                return true
            default:
                return false
            }
        }
}



