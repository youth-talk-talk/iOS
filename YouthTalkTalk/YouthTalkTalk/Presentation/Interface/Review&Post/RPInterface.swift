//
//  ReviewInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

enum RPType: Int {
    case review
    case post
    
    var title: String {
        switch self {
        case .review:
            return "후기게시판"
        case .post:
            return "자유게시판"
        }
    }
}

protocol RPInterface: RPInput, RPOutput {
    
    var input: RPInput { get }
    var output: RPOutput { get }
    
    var type: RPType { get }
}

