//
//  HomeOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeOutput {
    
    var popularPoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var recentPoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var resetSectionItems: PublishRelay<Void> { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }
    
    var errorHandler: PublishRelay<APIError> { get }
}
