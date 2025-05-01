//
//  RPOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol RPOutput {
    
    var popularRPsRelay: PublishRelay<[CommunitySectionItems]> { get set }
    var recentRPsRelay: PublishRelay<[CommunitySectionItems]> { get set }
    var resetSectionItems: PublishRelay<Void> { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }

}

