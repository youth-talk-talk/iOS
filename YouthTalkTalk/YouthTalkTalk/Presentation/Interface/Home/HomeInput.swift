//
//  HomeInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation
import RxCocoa

protocol HomeInput {
    
    var fetchPolicies: PublishRelay<Void> { get }
    var pageUpdate: PublishRelay<Int> { get }
    var policyCategorySeleted: PublishRelay<PolicyCategory> { get }
}
