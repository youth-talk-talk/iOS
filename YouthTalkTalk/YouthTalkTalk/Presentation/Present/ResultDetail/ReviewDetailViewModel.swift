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
    private let commentUseCase: CommentUseCase
    
    // Inputs
    var fetchDetailInfo = PublishRelay<Void>()
    
    // Outputs
    var detailInfo = PublishRelay<DetailRPEntity>()
    var commentsInfo = PublishRelay<[CommentDetailEntity]>()
    
    // Interface
    var input: ResultDetailInput { return self }
    var output: ResultDetailOutput { return self }
    
    
    init(data: RPEntity, useCase: ReviewUseCase, commnetUseCase: CommentUseCase) {
        
        self.rpEntity = data
        self.useCase = useCase
        self.commentUseCase = commnetUseCase
        
        guard let postId = data.postId else { return }
        
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
        
        commnetUseCase.fetchComments(postID: postId)
            .bind(with: self) { owner, result in
                
                switch result {
                case .success(let commentDetailEntities):
                    
                    owner.commentsInfo.accept(commentDetailEntities)
                    
                case .failure(let error):
                    owner.commentsInfo.accept([])
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
