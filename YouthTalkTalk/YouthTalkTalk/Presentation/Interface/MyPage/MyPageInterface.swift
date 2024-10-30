//
//  MyPageInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation
import RxCocoa

protocol MyPageInput {
    
    var fetchUpcomingScrapEvent: PublishRelay<Void> { get }
    var updatePolicyScrap: PublishRelay<String> { get }
}

protocol MyPageOutput {
    
    var upcomingScrapPolicies: PublishRelay<[PolicyEntity]> { get }
    var canceledScrapEntity: PublishRelay<ScrapEntity> { get }
    
}

protocol MyPageInterface: MyPageInput, MyPageOutput {
    
    var input: MyPageInput { get }
    var output: MyPageOutput { get }
}
