//
//  SignUpUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpUseCase {
    
    func signUp(region: String, nickname: String) -> Observable<Result<Void, APIError>>
}
