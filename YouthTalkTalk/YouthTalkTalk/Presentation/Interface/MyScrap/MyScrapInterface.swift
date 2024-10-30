//
//  MyScrapInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyScrapInput {
    
    var fetchScrapPoliciesEvent: PublishRelay<Void> { get }
    var updatePolicyScrap: PublishRelay<String> { get }
}

protocol MyScrapOutput {
    
    var scrapPolicies: PublishRelay<[PolicyEntity]> { get }
    var canceledScrapEntity: PublishRelay<ScrapEntity> { get }
    
}

protocol MyScrapInterface: MyScrapInput, MyScrapOutput {
    
    var input: MyScrapInput { get }
    var output: MyScrapOutput { get }
}
