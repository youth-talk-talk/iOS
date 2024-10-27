//
//  ReviewDetailViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ReviewDetailViewModel: ResultDetailInterface {
    
    let rpEntity: RPEntity
    
    private let disposeBag = DisposeBag()
    private let useCase: ReviewUseCase
    
    // Inputs
    var fetchDetailInfo = PublishRelay<Void>()
    
    // Outputs
    var detailInfo = PublishRelay<DetailRPEntity>()
    
    // Interface
    var input: ResultDetailInput { return self }
    var output: ResultDetailOutput { return self }
    
    
    init(data: RPEntity, useCase: ReviewUseCase) {
        
        self.rpEntity = data
        self.useCase = useCase
        
        useCase.fetchReviewDetail(id: rpEntity.postId!)
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let detailEntity):
                    
                    owner.detailInfo.accept(detailEntity)
                case .failure(let error):
                    dump(error)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
