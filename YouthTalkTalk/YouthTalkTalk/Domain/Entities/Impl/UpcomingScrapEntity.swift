//
//  UpcomingScrapEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation

struct UpcomingScrapEntity: Hashable {
    
    let policyId: String
    let category: String
    let title: String
    let deadlineStatus: String
    let hostDep: String
    let scrap: Bool
}
