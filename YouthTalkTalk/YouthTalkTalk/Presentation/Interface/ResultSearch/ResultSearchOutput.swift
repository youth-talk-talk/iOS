//
//  ResultSearchOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxCocoa

protocol ResultSearchOutput {
    
    var searchListRelay: PublishRelay<[ResultSearchSectionItems]> { get }
    var totalCountRelay: PublishRelay<Int> { get }
    var errorHandler: PublishRelay<APIError> { get }
    
    func fetchPage() -> Int
}