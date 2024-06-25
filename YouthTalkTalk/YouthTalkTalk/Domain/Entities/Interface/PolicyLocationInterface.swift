//
//  PolicyLocationInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation

protocol PolicyLocationInterface {
    
    var displayName: String { get }
    
    static var allCase: [PolicyLocationInterface] { get }
    
    static func fetchLocation(_ row: Int) -> PolicyLocationInterface
}
