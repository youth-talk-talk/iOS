//
//  UILabel++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/11/24.
//

import UIKit

extension UILabel {
    
    func designed(text: String, fontType: FontType, textColor: FontColor = .gray60) {
        
        self.text = text
        self.textColor = textColor.value
        self.font = FontManager.font(fontType)
        self.setTextWithLineHeight(text: text, lineHeight: FontManager.lineHeight(fontType))
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat){
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
