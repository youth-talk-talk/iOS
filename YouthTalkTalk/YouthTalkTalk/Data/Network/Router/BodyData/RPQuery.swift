//
//  RPQuery.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

struct RPQuery: Encodable {
    
    let categories: [PolicyCategory]
    let page: Int
    let size: Int
    
    init(categories: [PolicyCategory], page: Int, size: Int) {
        self.categories = categories
        self.page = page
        self.size = size
    }
}
