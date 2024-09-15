//
//  ResultPostViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResultPostViewModel: ResultSearchInterface {
    
    // Input
    var keyword: String
    var fetchSearchList = PublishRelay<Void>()
    var pageUpdate = PublishRelay<Int>()
    var searchType: ResultSearchType = .post
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var totalCountRelay = PublishRelay<Int>()
    var errorHandler = PublishRelay<APIError>()
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    init(_ keyword: String) {
        self.keyword = keyword
    }
    
    func updateData(age: Int?, employment: [String], isFinished: Bool?) { }
    
    func fetchPage() -> Int {
        return 0
    }
}
