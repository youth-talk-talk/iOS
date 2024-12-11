//
//  MyRPScrapInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyRPScrapInput {
    
    var fetchScrapEvent: PublishRelay<Void> { get }
    var updateScrap: PublishRelay<String> { get }
    
    var fetchLikedComment: PublishRelay<Void> { get }
}

protocol MyRPScrapOutput {
    
    var scrap: PublishRelay<[RPEntity]> { get }
    var canceledScrapEntity: PublishRelay<ScrapEntity> { get }
    
    var likedCommentList: PublishRelay<[LikedCommentData]> { get }
    
}

protocol MyRPScrapInterface: MyRPScrapInput, MyRPScrapOutput {
    
    var input: MyRPScrapInput { get }
    var output: MyRPScrapOutput { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }
}
