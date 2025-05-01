//
//  PaddedLabel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class PaddedLabel: UILabel {
    let topBottomInset: CGFloat
    let leftRightInset: CGFloat
    
    init(topBottom: CGFloat, leftRight: CGFloat) {
        self.topBottomInset = topBottom
        self.leftRightInset = leftRight
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topBottomInset, left: leftRightInset, bottom: topBottomInset, right: leftRightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftRightInset + leftRightInset,
                      height: size.height + topBottomInset + topBottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftRightInset + leftRightInset)
        }
    }
}
