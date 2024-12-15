//
//  ReviewDetailViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

final class PosetDetailViewModel: ResultDetailInterface {
    
    let rpEntity: RPEntity
    var commentWriterName: String = ""
    
    private let disposeBag = DisposeBag()
    private let useCase: ReviewUseCase
    private let commentUseCase: CommentUseCase
    
    // Inputs
    var fetchDetailInfo = PublishRelay<Void>()
    var deletePost = PublishRelay<Void>()
    
    // Outputs
    var detailInfo = PublishRelay<DetailRPEntity>()
    var commentsInfo = PublishRelay<[CommentDetailEntity]>()
    var userNickName: String = "" // MARK: 핸드폰 유저 닉네임
    var successDeleteComment = PassthroughSubject<Int, Never>()
    var successEditComment = PassthroughSubject<(commentId: Int, newComment: String), Never>()
    var successLikeComment = PassthroughSubject<(commentId: Int, isLiked: Bool), Never>()
    var successDeletePost = PassthroughSubject<Void, Never>()
    
    // Interface
    var input: ResultDetailInput { return self }
    var output: ResultDetailOutput { return self }
    
    var successUploadComment = PassthroughSubject<Int, Never>()
    var writtenCommentText = ""
    
    private lazy var memberUseCase: MemberUseCase = MemberUseCaseImpl(memberRepository: MemberRepositoryImpl())
    
    init(data: RPEntity, useCase: ReviewUseCase, commnetUseCase: CommentUseCase) {
        self.rpEntity = data
        self.useCase = useCase
        self.commentUseCase = commnetUseCase
        
        guard let postId = data.postId else { return }
        
        memberUseCase.fetchMe()     
            .bind(with: self) { owner, result in
            switch result {
            case .success(let meEntity):
                owner.userNickName = meEntity.nickname
            case .failure(let error):
                break
            }
        }
        .disposed(by: disposeBag)
        
        useCase.fetchReviewDetail(id: rpEntity.postId!)
            .bind(with: self) { [weak self] owner, result in
                
                switch result {
                case .success(let detailEntity):
                    self?.commentWriterName = detailEntity.nickname ?? "익명"
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
                }
            }
            .disposed(by: disposeBag)
        
        deletePost
            .flatMap { [weak self] in
                self!.useCase.deletePost(String(self!.rpEntity.postId ?? 0))
            }
            .bind(with: self) { owner, result in
                
                switch result {
                case .success:
                    owner.successDeletePost.send(())
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func uploadPostComment(_ body: UploadPostCommentBody) {
        useCase.uploadPostComment(body)
            .subscribe { [weak self] result in
                switch result {
                case .success(let data):
                    self?.writtenCommentText = body.content
                    
                    self?.successUploadComment.send(data.data.commentId)
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    func commentDelete(_ commentId: Int) {
        commentUseCase.commentDelete(commentId)
            .subscribe { [weak self] result in
                switch result {
                case .success:
                    self?.successDeleteComment.send(commentId)
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func editComment(commentId: Int, newComment: String) {
        commentUseCase.editComment(commentId, newComment)
            .subscribe { [weak self] result in
                switch result {
                case .success:
                    self?.successEditComment.send((commentId, newComment))
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func likeComment(_ commentId: Int, _ isSetLiked: Bool) {
        commentUseCase.likeComment(commentId, isSetLiked)
            .subscribe { [weak self] result in
                switch result {
                case .success:
                    self?.successLikeComment.send((commentId, isSetLiked))
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
