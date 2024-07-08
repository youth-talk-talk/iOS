//
//  SearchOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

import Foundation
import RxCocoa

protocol SearchOutput {
    
    var searchTypeEvent: BehaviorRelay<SearchViewType> { get }
}
