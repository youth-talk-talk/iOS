//
//  PostUseCase.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol PostUseCase {
    
    func fetchPosts(page: Int, size: Int) -> Observable<Result<CommunityRPEntity, APIError>>
    func fetchConditionPosts(keyword: String, page: Int, size: Int) -> Observable<Result<([RPEntity], Int), APIError>>
    func updatePostScrap(id: String) -> Observable<Result<ScrapEntity, APIError>>
    func fetchLikedComment() -> Observable<Result<LikedComment, APIError>>
    func fetchMyComment() -> Observable<Result<LikedComment, APIError>>
    func fetchMyPost(_ page: Int) -> Observable<Result<[MyPostData], APIError>>
    func fetchScrapPosts(page: Int, size: Int) -> Observable<Result<[RPEntity], APIError>>
}
