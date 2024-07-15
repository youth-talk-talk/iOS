//
//  HomePolicyBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation


enum PolicyCategory: CaseIterable, Encodable {
    
    case job
    case education
    case life
    case participation
    
    var name: String {
        
        switch self {
        case .job:
            return "JOB"
        case .education:
            return "EDUCATION"
        case .life:
            return "LIFE"
        case .participation:
            return "PARTICIPATION"
        }
    }
}

struct HomePolicyBody: Encodable {
    
    let categories: [PolicyCategory]
    let page: Int
    let size: Int
    
    init(categories: [PolicyCategory], page: Int, size: Int) {
        self.categories = categories
        self.page = page
        self.size = size
    }
}
