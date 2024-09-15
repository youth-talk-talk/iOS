//
//  ResultSearchInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxCocoa

protocol ResultSearchInput {
    
    var keyword: String { get }
    var fetchSearchList: PublishRelay<Void> { get }
    var pageUpdate: PublishRelay<Int> { get }
    
    func updateData(age: Int?, employment: [String], isFinished: Bool?)
}
