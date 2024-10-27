//
//  ResultDetailInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/20/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ResultDetailInput {
    
    var fetchDetailInfo: PublishRelay<Void> { get }
}

protocol ResultDetailOutput {
    
    var detailInfo: PublishRelay<DetailRPEntity> { get }
}

protocol ResultDetailInterface: ResultDetailInput, ResultDetailOutput {
    
    var input: ResultDetailInput { get }
    var output: ResultDetailOutput { get }
}
