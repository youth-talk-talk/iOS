//
//  PolicyLocation.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation

protocol PolicyLocation {
    
    var displayName: String { get }
    
    static var allCase: [PolicyLocation] { get }
    
    static func fetchLocation(_ row: Int) -> PolicyLocation
}
