//
//  FontManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import Foundation
import UIKit.UIFont

class FontManager {
    
    private init() { }
    
    /// 폰트
    static func font(_ fontType: FontType) -> UIFont {
        
        let familyName = "Pretendard-"
        var fontWeight = ""
        var fontSize: CGFloat = 0
        
        switch fontType {
        case .titleForPolicySemibold:
            
            fontWeight = "SemiBold"
            fontSize = 28
            
        case .titleForPolicyRegular:
            
            fontWeight = "Regular"
            fontSize = 22
            
        case .titleForAppBold:
            
            fontWeight = "Bold"
            fontSize = 22
            
        case .titleForAppRegular:
            
            fontWeight = "Regular"
            fontSize = 24
            
        case .titleForNormalSemiBold:
            
            fontWeight = "SemiBold"
            fontSize = 20
            
        case .titleForNormalRegular:
            
            fontWeight = "Regular"
            fontSize = 24
            
        case .subTitleForPolicyBold:
            
            fontWeight = "Bold"
            fontSize = 18
            
        case .subTitleForPolicyRegular:
            
            fontWeight = "Regular"
            fontSize = 18
            
        case .bodyBold:
            
            fontWeight = "Bold"
            fontSize = 16
            
        case .bodyRegular:
            
            fontWeight = "Regular"
            fontSize = 16
            
        case .bodyForCategorySemibold:
            
            fontWeight = "SemiBold"
            fontSize = 16
            
        case .bodyForPolicyBold:
            
            fontWeight = "Bold"
            fontSize = 14
            
        case .bodyForPolicyRegular:
            
            fontWeight = "Regular"
            fontSize = 14
            
        case .bodyForTermsSemibold:
            
            fontWeight = "SemiBold"
            fontSize = 12
            
        case .bodyForTermsRegular:
            
            fontWeight = "Regular"
            fontSize = 12
        }
        
        return UIFont(name: "\(familyName)\(fontWeight)", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// 폰트 별 높이 - Label에 사용
    static func lineHeight(_ fontType: FontType) -> CGFloat {
        
        var lineHeight: CGFloat = 0
        
        switch fontType {
        case .titleForPolicySemibold:
            lineHeight = 44
            
        case .titleForPolicyRegular:
            lineHeight = 32
            
        case .titleForAppBold:
            lineHeight = 32
            
        case .titleForAppRegular:
            lineHeight = 32
            
        case .titleForNormalSemiBold:
            lineHeight = 32
            
        case .titleForNormalRegular:
            lineHeight = 32
            
        case .subTitleForPolicyBold:
            lineHeight = 24
            
        case .subTitleForPolicyRegular:
            lineHeight = 24
            
        case .bodyBold:
            lineHeight = 24
            
        case .bodyRegular:
            lineHeight = 24
            
        case .bodyForCategorySemibold:
            lineHeight = 24
            
        case .bodyForPolicyBold:
            lineHeight = 20
            
        case .bodyForPolicyRegular:
            lineHeight = 20
            
        case .bodyForTermsSemibold:
            lineHeight = 16
            
        case .bodyForTermsRegular:
            lineHeight = 24
            
        }
        
        return lineHeight
    }
}
