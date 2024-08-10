//
//  PostRepositoryImpl.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

final class PostRepositoryImpl: PostRepository {
    
    private let apiManager = APIManager()
    
    func fetchPosts(page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>> {
        
        let rpQuery = RPQuery(page: page, size: size)
        
        let router = PostRouter.fetchPost(query: rpQuery)
        
        return apiManager.request(router: router, type: CommunityRPDTO.self).asObservable()
    }
}
