//
//  MyScrapRPViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyScrapRPViewModel: MyRPScrapInterface {
    
    private var disposeBag = DisposeBag()
    private var useCase: PostUseCase
    
    var input: MyRPScrapInput { return self }
    var output: MyRPScrapOutput { return self }
    
    // Inputs
    var fetchScrapEvent = PublishRelay<Void>()
    var updateScrap = PublishRelay<String>()
    
    // Outputs
    var scrap = PublishRelay<[RPEntity]>()
    // var canceledScrapEntity = PublishRelay<ScrapEntity>()
    
    init(useCase: PostUseCase) {
        self.useCase = useCase
        
        fetchScrapEvent
            .flatMap { _ in
                
                return useCase.fetchScrapPosts(page: 0, size: 10)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let rpEntities):
                    owner.scrap.accept(rpEntities)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 스크랩
        // updateScrap
        //     .withUnretained(self)
        //     .flatMap { owner, policyID in
        //         return owner.useCase.updatePolicyScrap(id: policyID)
        //     }
        //     .subscribe(with: self) { owner, result in
        //         
        //         switch result {
        //         case .success(let scrapEntity):
        //             owner.canceledScrapEntity.accept(scrapEntity)
        //         case .failure(let error):
        //             print(error)
        //         }
        //     }
        //     .disposed(by: disposeBag)
    }
}
