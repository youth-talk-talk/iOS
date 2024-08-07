//
//  DetailPolicyDTO.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation

struct DetailPolicyDTO: Decodable {
    
    let status: Int
    let message: String
    let code: String
    let data: DetailPolicyDataDTO
}

struct DetailPolicyDataDTO: Decodable {
    
    let title: String
    let introduction: String?
    let supportDetail: String?
    let applyTerm: String?
    let operationTerm: String?
    let age: String
    let addrIncome: String?
    let education: String?
    let major: String?
    let employment: String?
    let specialization: String?
    let applLimit: String?
    let addition: String?
    let applStep: String?
    let evaluation: String?
    let applUrlv: String?
    let submitDocv: String?
    let etcv: String?
    let hostDep: String?
    let operatingOrg: String?
    let refUrl1: String?
    let refUrl2: String?
    let formattedApplUrl: String?
    let isScrap: Bool
    
    func translateDetailPolicyEntity() -> DetailPolicyEntity {
        
        let summary = DetailPolicyEntity.PolicySummary(hostDep: self.hostDep,
                                                       title: self.title,
                                                       introduction: self.introduction,
                                                       supportDetail: self.supportDetail,
                                                       applyTerm: self.applyTerm,
                                                       operationTerm: self.operationTerm)
        
        let target = DetailPolicyEntity.PolicyTarget(age: self.age,
                                                     addrIncome: self.addrIncome,
                                                     education: self.education,
                                                     major: self.major,
                                                     employment: self.employment,
                                                     specialization: self.specialization,
                                                     applLimit: self.applLimit,
                                                     addition: self.addition)
        
        let method = DetailPolicyEntity.PolicyMethod(applStep: self.applStep,
                                                     evaluation: self.evaluation,
                                                     applUrl: self.applUrlv,
                                                     submitDoc: self.submitDocv)
        
        let detail = DetailPolicyEntity.PolicyDetail(etc: self.etcv,
                                                     hostDep: self.hostDep,
                                                     operatingOrg: self.operatingOrg,
                                                     refUrl1: self.refUrl1,
                                                     refUrl2: self.refUrl2,
                                                     formattedApplUrl: self.formattedApplUrl, 
                                                     applUrlv: self.applUrlv)
        
        
        return DetailPolicyEntity(summary: summary,
                                  target: target,
                                  method: method,
                                  detail: detail,
                                  isScrap: self.isScrap)
    }
}
