//
//  RPQuery.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

struct RPQuery: Encodable {
    
    let page: Int
    let size: Int
    
    init(page: Int, size: Int) {
        self.page = page
        self.size = size
    }
}
