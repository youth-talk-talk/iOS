//
//  HomeInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//

import Foundation

protocol HomeInterface: HomeInput, HomeOutput {
    
    var input: HomeInput { get }
    var output: HomeOutput { get }
}
