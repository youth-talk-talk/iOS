//
//  NSObject++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import Foundation

extension NSObject {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
