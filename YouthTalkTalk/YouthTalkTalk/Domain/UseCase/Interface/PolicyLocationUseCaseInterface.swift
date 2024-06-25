//
//  PolicyLocationUseCaseInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxSwift

protocol PolicyLocationUseCaseInterface {
    
    func fetchAllCase(entity: PolicyLocationInterface.Type) -> [PolicyLocationInterface]
    
    func fetchLocation(_ row: Int, entity: PolicyLocationKR.Type) -> PolicyLocationInterface
}
