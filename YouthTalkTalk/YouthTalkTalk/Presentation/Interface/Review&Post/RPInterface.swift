//
//  ReviewInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

enum RPType {
    case review
    case post
}

protocol RPInterface: RPInput, RPOutput {
    
    var input: RPInput { get }
    var output: RPOutput { get }
    
    var type: RPType { get }
}

