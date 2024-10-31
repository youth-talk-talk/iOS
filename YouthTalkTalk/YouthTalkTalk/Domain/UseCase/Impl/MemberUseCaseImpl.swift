//
//  MemberUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift

final class MemberUseCaseImpl: MemberUseCase {
    
    private let disposeBag = DisposeBag()
    private let memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func fetchMe() -> Observable<Result<MeEntity, APIError>> {
        
        return memberRepository.fetchMe()
            .withUnretained(self)
            .map { owner, result in
                
                switch result {
                    
                case .success(let meDataDTO):
                    
                    let data = meDataDTO.data
                    let meEntity = MeEntity(nickname: data.nickname, email: data.email, region: data.region)
                    
                    return .success(meEntity)
                case .failure(let error):
                    
                    return .failure(error)
                }
            }
    }
}
