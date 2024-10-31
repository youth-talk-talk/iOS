//
//  MemberRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MemberRepositoryImpl: MemberRepository {
    
    private let disposeBag = DisposeBag()
    private let apiManager = APIManager()
    
    func fetchMe() -> Observable<Result<MeDTO, APIError>> {
        
        let router = MeRouter.requestMe
        
        return apiManager.request(router: router, type: MeDTO.self).asObservable()
    }
}
