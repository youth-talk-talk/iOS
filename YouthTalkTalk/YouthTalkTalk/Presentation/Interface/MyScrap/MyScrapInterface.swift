//
//  MyScrapInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyScrapInput {
    
    var fetchScrapEvent: PublishRelay<Void> { get }
    var updateScrap: PublishRelay<String> { get }
}

protocol MyScrapOutput {
    
    var scrap: PublishRelay<[PolicyEntity]> { get }
    var canceledScrapEntity: PublishRelay<ScrapEntity> { get }
    
}

protocol MyScrapInterface: MyScrapInput, MyScrapOutput {
    
    var input: MyScrapInput { get }
    var output: MyScrapOutput { get }
}
