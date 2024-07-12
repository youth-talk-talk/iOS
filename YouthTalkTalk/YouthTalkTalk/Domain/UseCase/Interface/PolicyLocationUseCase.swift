//
//  PolicyLocationUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxSwift

protocol PolicyLocationUseCase {
    
    func fetchAllCase(entity: PolicyLocation.Type) -> [PolicyLocation]
    
    func fetchLocation(_ row: Int, entity: PolicyLocation.Type) -> PolicyLocation
    
    func fetchLocationByDisplayName(displayName: String, entity: PolicyLocation.Type) -> PolicyLocation
}
