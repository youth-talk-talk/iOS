//
//  ResultSearchInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation

protocol ResultSearchInterface: ResultSearchInput, ResultSearchOutput {

    var input: ResultSearchInput { get }
    var output: ResultSearchOutput { get }
}
