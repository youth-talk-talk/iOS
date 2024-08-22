//
//  PolicyScrapEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/22/24.
//

import Foundation

struct ScrapEntity {
    
    let isScrap: Bool
    let id: String
    
    init(isScrap: Bool, id: String) {
        self.isScrap = isScrap
        self.id = id
    }
    
    func isSameID(_ id: String) -> Bool {
        
        return self.id == id
    }
}
