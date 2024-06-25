//
//  PolicyLocationUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxSwift

final class PolicyLocationUseCase: PolicyLocationUseCaseInterface {
    
    func fetchAllCase(entity: PolicyLocationInterface.Type) -> [PolicyLocationInterface] {
        
        return entity.allCase
    }
    
    func fetchLocation(_ row: Int, entity: PolicyLocationKR.Type) -> PolicyLocationInterface {
        
        return entity.fetchLocation(row)
    }
}
