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
    
    func fetchLocation(_ row: Int, entity: PolicyLocation.Type) -> PolicyLocation {
        
        return entity.fetchLocation(row)
    }
    
    func fetchLocationByDisplayName(displayName: String, entity: PolicyLocation.Type) -> PolicyLocation {
        
        guard let selectedLocation = entity.allCase.filter({ location in
            location.displayName == displayName
        }).first else {
            return entity.fetchLocation(0)
        }
        
        return selectedLocation
    }
}
