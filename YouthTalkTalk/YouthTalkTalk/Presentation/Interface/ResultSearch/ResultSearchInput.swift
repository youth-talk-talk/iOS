//
//  ResultSearchInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxCocoa

protocol ResultSearchInput {
    
    var fetchSearchList: PublishRelay<Void> { get }
}
