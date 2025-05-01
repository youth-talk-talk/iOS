//
//  ResultSearchOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxCocoa
import Combine

protocol ResultSearchOutput {
    
    var searchListRelay: PublishRelay<[ResultSearchSectionItems]> { get }
    var totalCountRelay: PublishRelay<Int> { get }
    var errorHandler: PublishRelay<APIError> { get }
    var scrapStatus: [String: Bool] { get }
    var scrapStatusRelay: BehaviorRelay<[String: Bool]> { get }
    var successEditPost: PassthroughSubject<UploadPostBody, Never> { get }
    
    func setKeyword(_ keyword: String)
    func uploadImages(_ images: [Data?], body: UploadPostBody, _ writeType: WriteType, postId: Int)
    func fetchPage() -> Int
}
