//
//  UILabel++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/11/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UILabel {
    
    func designed(text: String, fontType: FontType, textColor: FontColor = .gray60) {
        
        self.text = text
        self.textColor = textColor.value
        self.font = FontManager.font(fontType)
        self.lineBreakMode = .byTruncatingTail
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

extension Reactive where Base: UILabel {
    
    var textChanged: ControlEvent<String?> {
        let source = self.methodInvoked(#selector(setter: UILabel.text))
            .map { _ in
                return self.base.text
            }
            .startWith(self.base.text) // 초기 값 방출
            .distinctUntilChanged() // 값이 변경된 경우에만 방출
            
        return ControlEvent(events: source)
    }
}
