//
//  FontColor.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/14/24.
//

import UIKit.UIColor

enum FontColor {
    
    var value: UIColor {
        
        switch self {
        case .lightGray:
            
            return .customLightGray
        case .semiLightGray:
            
            return .semiLightGray
        case .baseGray:
            
            return .baseGray
        case .midGray:
            
            return .midGray
        case .semiDarkGray:
            
            return .semiDarkGray
        case .darkGray:
            
            return .customDarkGray
        }
    }
    
    case lightGray
    case semiLightGray
    case baseGray
    case midGray
    case semiDarkGray
    case darkGray
}
