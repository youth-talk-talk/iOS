//
//  SearchInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

import Foundation

protocol SearchInterface: SearchInput, SearchOutput {
    
    var type: RecentSearchType { get }
    
    var input: SearchInput { get }
    var output: SearchOutput { get }
}
