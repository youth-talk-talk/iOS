//
//  PolicyLocationUseCaseImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxSwift

final class PolicyLocationUseCaseImpl: PolicyLocationUseCase {
    
    func fetchAllCase(entity: PolicyLocation.Type) -> [PolicyLocation] {
        
        return entity.allCase
    }
    
    func fetchLocation(_ row: Int, entity: PolicyLocationKR.Type) -> PolicyLocation {
        
        return entity.fetchLocation(row)
    }
}
