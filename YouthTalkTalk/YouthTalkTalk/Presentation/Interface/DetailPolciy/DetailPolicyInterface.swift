//
//  DetailPolicyInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation

protocol DetailPolicyInterface: DetailPolicyInput, DetailPolicyOutput {
    
    var input: DetailPolicyInput { get }
    var output: DetailPolicyOutput { get }
}
