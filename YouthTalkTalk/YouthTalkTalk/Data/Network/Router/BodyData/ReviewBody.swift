//
//  ReviewBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation

struct ReviewBody: Encodable {
    
    let categories: [String]
    
    init(categories: [String]) {
        self.categories = categories
    }
}
