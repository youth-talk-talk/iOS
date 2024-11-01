//
//  DetailPolicyEntity.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation

struct DetailPolicyEntity {
    
    struct PolicySummary: Hashable {
        let hostDep: String?
        let title: String
        let introduction: String?
        let supportDetail: String?
        let applyTerm: String?
        let operationTerm: String?
    }

    struct PolicyTarget: Hashable {
        let age: String
        let addrIncome: String?
        let education: String?
        let major: String?
        let employment: String?
        let specialization: String?
        let applLimit: String?
        let addition: String?
    }

    struct PolicyMethod: Hashable {
        let applStep: String?
        let evaluation: String?
        let applUrl: String?
        let submitDoc: String?
    }

    struct PolicyDetail: Hashable {
        let etc: String?
        let hostDep: String?
        let operatingOrg: String?
        let refUrl1: String?
        let refUrl2: String?
        let formattedApplUrl: String?
        let applUrlv: String?
    }

    let summary: PolicySummary
    let target: PolicyTarget
    let method: PolicyMethod
    let detail: PolicyDetail
    let isScrap: Bool
}
