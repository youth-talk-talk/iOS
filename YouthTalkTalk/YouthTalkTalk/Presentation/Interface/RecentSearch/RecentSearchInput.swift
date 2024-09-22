//
//  RecentSearchInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import Foundation
import RxCocoa

protocol RecentSearchInput {
    
    var clickRecentKeywordEvent: ((String) -> Void)? { get }
    
    var clickRecentKeyword: PublishRelay<String> { get }
    var fetchRecentSearchList: PublishRelay<Void> { get }
    var removeRecentSearchList: PublishRelay<String> { get }
}
