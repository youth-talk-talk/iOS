//
//  DetailPolicyInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation
import RxCocoa

protocol DetailPolicyInput {
    
    var policyID: String { get }
    
    var fetchPolicyDetail: PublishRelay<String> { get }
}
