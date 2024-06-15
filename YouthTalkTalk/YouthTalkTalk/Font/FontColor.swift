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
        case .gray10:
            
            return .gray10
        case .gray20:
            
            return .gray20
        case .gray30:
            
            return .gray30
        case .gray40:
            
            return .gray40
        case .gray50:
            
            return .gray50
        case .gray60:
            
            return .gray60
        }
    }
    
    case gray10
    case gray20
    case gray30
    case gray40
    case gray50
    case gray60
}
