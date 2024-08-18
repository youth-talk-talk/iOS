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
    
    var topFivePoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var allPoliciesRelay: PublishRelay<[HomeSectionItems]> { get }
    var resetSectionItems: PublishRelay<Void> { get }
}
