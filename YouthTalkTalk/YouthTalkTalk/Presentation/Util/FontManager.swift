//
//  FontManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import Foundation
import UIKit.UIFont

enum FontType {
 
    case p24Bold
    
    case p18Bold
    
    case p16Bold
    case p16SemiBold
    case p16Regular24
    case p16Regular16
    
    case p14Bold
    case p14Regular
    
    case p12Bold
    case p12Regular
    
    case p10Regular
    
    case g20Bold
    case g14Bold
}

enum FontColor {
    
    var value: UIColor {
        
        switch self {
        case .white:
            
            return .white
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
            
        case .black:
            
            return .black
        }
    }
    
    case white
    case gray10
    case gray20
    case gray30
    case gray40
    case gray50
    case gray60
    case black
}

final class FontManager {
    
    private init() { }
    
    /// 폰트
    static func font(_ fontType: FontType) -> UIFont {
        
        var familyName = "Pretendard-"
        var fontWeight = ""
        var fontSize: CGFloat = 0
        
        switch fontType {
        case .p24Bold:
            
            fontWeight = "Bold"
            fontSize = 24
            
        case .p18Bold:
            
            fontWeight = "Bold"
            fontSize = 18
            
        case .p16Bold:
            
            fontWeight = "Bold"
            fontSize = 16
            
        case .p16SemiBold:
            
            fontWeight = "SemiBold"
            fontSize = 16
            
        case .p16Regular24:
            
            fontWeight = "Regular"
            fontSize = 16
            
        case .p16Regular16:
            
            fontWeight = "Regular"
            fontSize = 16
            
        case .p14Bold:
            
            fontWeight = "Bold"
            fontSize = 14
            
        case .p14Regular:
            
            fontWeight = "Regular"
            fontSize = 14
            
        case .p12Bold:
            
            fontWeight = "Bold"
            fontSize = 12
            
        case .p12Regular:
            
            fontWeight = "Regular"
            fontSize = 12
            
        case .p10Regular:
            
            fontWeight = "Regular"
            fontSize = 10
            
        case .g20Bold:
            
            familyName = "GmarketSans"
            fontWeight = "Bold"
            fontSize = 20
            
        case .g14Bold:
            
            familyName = "GmarketSans"
            fontWeight = "Bold"
            fontSize = 14
            
        }
        
        return UIFont(name: "\(familyName)\(fontWeight)", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// 폰트 별 높이 - Label에 사용
    static func lineHeight(_ fontType: FontType) -> CGFloat {
        
        var lineHeight: CGFloat = 0
        
        switch fontType {
        case .p24Bold:
            lineHeight = 24
        case .p18Bold:
            lineHeight = 24
        case .p16Bold:
            lineHeight = 24
        case .p16SemiBold:
            lineHeight = 24
        case .p16Regular24:
            lineHeight = 24
        case .p16Regular16:
            lineHeight = 16
        case .p14Bold:
            lineHeight = 24
        case .p14Regular:
            lineHeight = 24
        case .p12Bold:
            lineHeight = 16
        case .p12Regular:
            lineHeight = 16
        case .p10Regular:
            lineHeight = 16
        case .g20Bold:
            lineHeight = 24
        case .g14Bold:
            lineHeight = 24
        }
        
        return lineHeight
    }
}

