//
//  RecentSearchOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import Foundation
import RxCocoa

protocol RecentSearchOutput {
    
    var recentSearchListRelay: PublishRelay<[String]> { get }
}
