//
//  ErrorDescription.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation

protocol NetworkError: Error {
    
    var description: String { get }
}
