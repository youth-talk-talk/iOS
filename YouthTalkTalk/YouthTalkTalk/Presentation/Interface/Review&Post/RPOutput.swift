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
    
    var popularRPsRelay: PublishRelay<[CommunitySectionItems]> { get }
    var recentRPsRelay: PublishRelay<[CommunitySectionItems]> { get }
}

