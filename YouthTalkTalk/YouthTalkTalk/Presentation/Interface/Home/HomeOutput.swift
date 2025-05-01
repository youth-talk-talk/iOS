//
//  HomeOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxCocoa
import RxSwift

enum HomeSectionItems: Hashable {
    
    case category
    case popular(PolicyEntity)
    case recent(PolicyEntity)
    
    var data: PolicyEntity? {
        switch self {
        case .category:
            return nil
        case .popular(let policyEntity):
            return policyEntity
        case .recent(let policyEntity):
            return policyEntity
        }
    }
}


protocol HomeOutput {
    
    var popularPoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var recentPoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var resetSectionItems: PublishRelay<Void> { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }
    
    var errorHandler: PublishRelay<APIError> { get }
}
