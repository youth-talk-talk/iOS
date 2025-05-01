//
//  MyRPScrapInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

protocol MyRPScrapInput {
    
    var fetchScrapEvent: PublishRelay<Void> { get }
    var updateScrap: PublishRelay<String> { get }
    
    var fetchLikedComment: PublishRelay<Void> { get }
    var fetchMyComment: PublishRelay<Void> { get }
    var fetchMyPost: PublishRelay<Int> { get }

    func commentDelete(_ commentId: Int)
    func editComment(commentId: Int, newComment: String)
}

protocol MyRPScrapOutput {
    
    var scrap: PublishRelay<[RPEntity]> { get }
    var canceledScrapEntity: PublishRelay<ScrapEntity> { get }
    var successDeleteComment: PassthroughSubject<Int, Never> { get }
    var successEditComment: PassthroughSubject<(commentId: Int, newComment: String), Never> { get }

    var likedCommentList: PublishRelay<[LikedCommentData]> { get }
    var myCommentList: PublishRelay<[LikedCommentData]> { get }
    var myPost: PublishRelay<[RPEntity]> { get }
}

protocol MyRPScrapInterface: MyRPScrapInput, MyRPScrapOutput {
    
    var input: MyRPScrapInput { get }
    var output: MyRPScrapOutput { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }
}
