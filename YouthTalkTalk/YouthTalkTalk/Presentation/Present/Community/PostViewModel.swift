//
//  PostViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel: RPInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let useCase: PostUseCase
    
    var type: MainContentsType = .freePost
    var selectedPolicyCategory: [PolicyCategory] = PolicyCategory.allCases
    
    var fetchRPs = PublishRelay<Void>()
    var updateRecentRPs = PublishRelay<Int>()
    var pageUpdate = PublishRelay<Int>()
    var updatePostScrap = PublishRelay<String>()
    var scrapStatus = [String: Bool]()
    var scrapStatusRelay = BehaviorRelay<[String: Bool]>(value: [:])
    
    var popularRPsRelay = PublishRelay<[CommunitySectionItems]>()
    var recentRPsRelay = PublishRelay<[CommunitySectionItems]>()
    var resetSectionItems = PublishRelay<Void>()
    
    var input: RPInput { return self }
    var output: RPOutput { return self }
    
    init(rpUseCase: PostUseCase) {
        self.useCase = rpUseCase
        
        fetchRPs
            .withUnretained(self)
            .flatMap { owner, _ in
                
                return owner.useCase.fetchPosts(page: 1, size: 10)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let communityRPEntity):
                    
                    let popular = communityRPEntity.popularRP.map { CommunitySectionItems.popular($0) }
                    let recent = communityRPEntity.recentRP.map { CommunitySectionItems.recent($0) }
                    
                    owner.popularRPsRelay.accept(popular)
                    owner.recentRPsRelay.accept(recent)
                    
                case .failure(let error):
                    break
                }
            }
            .disposed(by: disposeBag)
        
        updatePostScrap
            .withUnretained(self)
            .flatMap { owner, policyID in
                
                return owner.useCase.updatePostScrap(id: policyID)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let scrapEntity):
                    // TODO: viewmodel에서 cell에 넣는 데이터 원본의 scrpas count 수정하기
                    owner.scrapStatus["\(scrapEntity.id)"] = scrapEntity.isScrap
                    owner.scrapStatusRelay.accept(owner.scrapStatus)
                    
                case .failure(let error):
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
