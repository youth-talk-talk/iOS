//
//  PolicyViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation
import RxCocoa
import RxSwift

final class PolicyViewModel: DetailPolicyInterface {
    
    let policyID: String
    
    var input: DetailPolicyInput { return self }
    var output: DetailPolicyOutput { return self }
    
    init(policyID: String) {
        self.policyID = policyID
    }
}
