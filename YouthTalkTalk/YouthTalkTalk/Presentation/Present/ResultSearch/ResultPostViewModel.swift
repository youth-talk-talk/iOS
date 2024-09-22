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
    
    private let disposeBag = DisposeBag()
    private let postUseCase: PostUseCase
    
    // Input
    var keyword: String
    var fetchSearchList = PublishRelay<Void>()
    var pageUpdate = PublishRelay<Int>()
    var searchType: ResultSearchType = .post
    var updatePolicyScrap = PublishRelay<String>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var totalCountRelay = PublishRelay<Int>()
    var errorHandler = PublishRelay<APIError>()
    var scrapStatus = [String: Bool]()
    var scrapStatusRelay = BehaviorRelay<[String: Bool]>(value: [:])
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    init(_ keyword: String, useCase: PostUseCase) {
        self.keyword = keyword
        self.postUseCase = useCase
        
        fetchSearchList
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.postUseCase.fetchConditionPosts(keyword: keyword, page: 0, size: 10)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let data):
                    
                    let (rpEntities, total) = data
                    
                    let recentReviews = rpEntities.map { ResultSearchSectionItems.resultRP($0) }
                    
                    owner.searchListRelay.accept(recentReviews)
                    owner.totalCountRelay.accept(total)
                    
                case .failure(let apiError):
                    print(apiError.msg)
                }
                
            }
            .disposed(by: disposeBag)
        
        // 스크랩
        updatePolicyScrap
            .withUnretained(self)
            .flatMap { owner, postID in
                
                return owner.postUseCase.updatePostScrap(id: postID)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let scrapEntity):
                    
                    owner.scrapStatus[scrapEntity.id] = scrapEntity.isScrap
                    owner.scrapStatusRelay.accept(owner.scrapStatus)
                    
                case .failure(let error):
                    owner.errorHandler.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func updateData(age: Int?, employment: [String], isFinished: Bool?) { }
    
    func fetchPage() -> Int {
        return 0
    }
}
