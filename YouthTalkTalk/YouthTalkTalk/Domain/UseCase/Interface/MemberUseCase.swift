//
//  MemberUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift

protocol MemberUseCase {
    
    func fetchMe() -> Observable<Result<MeEntity, APIError>>
}
