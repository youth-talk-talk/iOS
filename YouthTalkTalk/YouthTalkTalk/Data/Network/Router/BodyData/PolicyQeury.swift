//
//  HomePolicyBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation


enum PolicyCategory: String, CaseIterable, Encodable {
    
    case job = "JOB"
    case education = "EDUCATION"
    case life = "LIFE"
    case participation = "PARTICIPATION"
    
    var name: String {
        
        switch self {
        case .job:
            return "일자리"
        case .education:
            return "교육"
        case .life:
            return "생활지원"
        case .participation:
            return "참여"
        }
    }
}

struct PolicyQuery: Encodable {
    
    let categories: [PolicyCategory]
    let page: Int
    let size: Int
    
    init(categories: [PolicyCategory], page: Int, size: Int) {
        self.categories = categories
        self.page = page
        self.size = size
    }
}
