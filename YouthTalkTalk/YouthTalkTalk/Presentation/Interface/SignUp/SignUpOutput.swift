//
//  SignUpOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxCocoa

protocol SignUpOutput {
    
    var policyLocations: Driver<[PolicyLocationInterface]> { get }
    var selectedLocation: Driver<PolicyLocationInterface> { get }
}
