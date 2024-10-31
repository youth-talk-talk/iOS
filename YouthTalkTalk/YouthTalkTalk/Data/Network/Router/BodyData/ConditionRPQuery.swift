//
//  File.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/22/24.
//

import Foundation

struct ConditionRPQuery: Encodable {
    
    let type: MainContentsType
    let keyword: String
    let size: Int
    let page: Int
    
    init(type: MainContentsType, keyword: String, size: Int, page: Int) {
        self.type = type
        self.keyword = keyword
        self.size = size
        self.page = page
    }
}
