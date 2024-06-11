//
//  UILable++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/11/24.
//

import UIKit

extension UILabel {
    
    func designed(text: String, fontType: FontType) {
        
        var familyName = "Pretendard-"
        var fontWeight = ""
        var lineHeight: CGFloat = 0
        var fontSize: CGFloat = 0
        
        switch fontType {
        case .titleForPolicySemibold:
            
            fontWeight = "SemiBold"
            lineHeight = 44
            fontSize = 28
            
        case .titleForPolicyRegular:
            
            fontWeight = "Regular"
            lineHeight = 32
            fontSize = 22
            
        case .titleForAppBold:
            
            fontWeight = "Bold"
            lineHeight = 32
            fontSize = 22
            
        case .titleForAppRegular:
            
            fontWeight = "Regular"
            lineHeight = 32
            fontSize = 24
            
        case .titleForNormalSemiBold:
            
            fontWeight = "SemiBold"
            lineHeight = 32
            fontSize = 20
            
        case .titleForNormalRegular:
            
            fontWeight = "Regular"
            lineHeight = 32
            fontSize = 24
            
        case .subTitleForPolicyBold:
            
            fontWeight = "Bold"
            lineHeight = 24
            fontSize = 18
            
        case .subTitleForPolicyRegular:
            
            fontWeight = "Regular"
            lineHeight = 24
            fontSize = 18
            
        case .bodyBold:
            
            fontWeight = "Bold"
            lineHeight = 24
            fontSize = 16
            
        case .bodyRegular:
            
            fontWeight = "Regular"
            lineHeight = 24
            fontSize = 16
            
        case .bodyForCategorySemibold:
            
            fontWeight = "SemiBold"
            lineHeight = 24
            fontSize = 16
            
        case .bodyForPolicyBold:
            
            fontWeight = "Bold"
            lineHeight = 20
            fontSize = 14
            
        case .bodyForPolicyRegular:
            
            fontWeight = "Regular"
            lineHeight = 20
            fontSize = 14
            
        case .bodyForTermsSemibold:
            
            fontWeight = "SemiBold"
            lineHeight = 16
            fontSize = 12
            
        case .bodyForTermsRegular:
            
            fontWeight = "Regular"
            lineHeight = 24
            fontSize = 16
        }
        
        self.text = text
        self.font = .init(name: "\(familyName)\(fontWeight)", size: fontSize)
        self.setTextWithLineHeight(text: text, lineHeight: lineHeight)
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat){
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
