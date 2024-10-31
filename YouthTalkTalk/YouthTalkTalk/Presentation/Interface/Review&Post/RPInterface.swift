//
//  ReviewInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

protocol RPInterface: RPInput, RPOutput {
    
    var input: RPInput { get }
    var output: RPOutput { get }
    
    var type: MainContentsType { get }
    
    var selectedPolicyCategory: [PolicyCategory] { get }
}

