//
//  SearchInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

import Foundation
import RxCocoa

protocol SearchInput {
    
    var searchButtonClicked: PublishRelay<String> { get }
    var cancelButtonClicked: PublishRelay<Void> { get }
}
