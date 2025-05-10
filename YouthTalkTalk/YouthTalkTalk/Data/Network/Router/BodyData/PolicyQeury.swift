//
//  HomePolicyBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation


enum PolicyCategory: String, CaseIterable, Encodable {
    case all = ""
    case job = "JOB"
    case education = "EDUCATION"
    case life = "LIFE"
    case participation = "PARTICIPATION"
    case dwelling = "DWELLING"
    
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
        case .dwelling:
            return "주거"
        case .all:
            return "전체"
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
