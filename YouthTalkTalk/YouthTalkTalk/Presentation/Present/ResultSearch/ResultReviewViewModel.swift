//
//  ResultReviewViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResultReviewViewModel: ResultSearchInterface {
    
    // Input
    var keyword: String
    var fetchSearchList = PublishRelay<Void>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var errorHandler = PublishRelay<APIError>()
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    init(_ keyword: String) {
        self.keyword = keyword
    }
}
