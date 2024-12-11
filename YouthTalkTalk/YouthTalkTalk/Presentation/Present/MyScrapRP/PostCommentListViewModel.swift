//
//  MyScrapRPViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ListType {
    case scrapPost
    case likedComment
    case myWrittenComment
}

final class PostCommentListViewModel: MyRPScrapInterface {
    
    private var disposeBag = DisposeBag()
    private var useCase: PostUseCase
    
    var input: MyRPScrapInput { return self }
    var output: MyRPScrapOutput { return self }
    
    var scrapStatus = [String: Bool]()
    var scrapStatusRelay = BehaviorRelay<[String: Bool]>(value: [:])
    
    // Inputs
    var fetchScrapEvent = PublishRelay<Void>()
    var updateScrap = PublishRelay<String>()
    var fetchLikedComment = PublishRelay<Void>()
    var fetchMyComment = PublishRelay<Void>()
    
    // Outputs
    var scrap = PublishRelay<[RPEntity]>()
    var canceledScrapEntity = PublishRelay<ScrapEntity>()
    var likedCommentList = PublishRelay<[LikedCommentData]>()
    var myCommentList = PublishRelay<[LikedCommentData]>()
    
    init(useCase: PostUseCase, listType: ListType) {
        self.useCase = useCase
        
        if listType == .scrapPost {
            fetchScrapEvent
                .flatMap { _ in
                    
                    return useCase.fetchScrapPosts(page: 0, size: 10)
                }
                .bind(with: self) { owner, result in
                    switch result {
                    case .success(let rpEntities):
                        owner.scrap.accept(rpEntities)
                    case .failure:
                        break
                    }
                }
                .disposed(by: disposeBag)
            
            // 스크랩
            updateScrap
                .withUnretained(self)
                .flatMap { owner, policyID in
                    return owner.useCase.updatePostScrap(id: policyID)
                }
                .subscribe(with: self) { owner, result in
                    
                    switch result {
                    case .success(let scrapEntity):
                        owner.scrapStatus[scrapEntity.id] = scrapEntity.isScrap
                        owner.scrapStatusRelay.accept(owner.scrapStatus)
                        owner.canceledScrapEntity.accept(scrapEntity)
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
            
        } else if listType == .likedComment {
            fetchLikedComment
                .withUnretained(self)
                .flatMap { _ in
                    return useCase.fetchLikedComment()
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let scrapEntity):
                        owner.likedCommentList.accept(scrapEntity.data)
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
            
        } else if listType == .myWrittenComment {
            fetchMyComment
                .withUnretained(self)
                .flatMap { _ in
                    return useCase.fetchMyComment()
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let scrapEntity):
                        owner.myCommentList.accept(scrapEntity.data)
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
}
