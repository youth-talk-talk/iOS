//
//  ReviewRepository.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxSwift

protocol ReviewRepository {
    
    func fetchReviews(categories: [PolicyCategory], page: Int, size: Int) -> Observable<Result<CommunityRPDTO, APIError>>
    // func fetchPolicyDetail(id: String) -> Observable<Result<DetailPolicyDTO, APIError>>
}
