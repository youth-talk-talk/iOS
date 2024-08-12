//
//  RecentSearchInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import Foundation

protocol RecentSearchInterface: RecentSearchInput, RecentSearchOutput {
    
    var type: RecentSearchType { get }

    var input: RecentSearchInput { get }
    var output: RecentSearchOutput { get }
}
