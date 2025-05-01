//
//  MemberRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift

protocol MemberRepository {
    
    func fetchMe() -> Observable<Result<MeDTO, APIError>>
    func deleteAccount() -> Observable<Result<DeleteAccountDTO, APIError>>
}
