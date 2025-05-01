//
//  UITextField++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit

extension UITextField {

    func makeLeftPaddingView() {
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        
        self.leftView = leftPadding
        self.leftViewMode = .always
    }
    
    func designedPlaceholder(placeholder: String, textColor: UIColor = .gray40, font: FontType = .p16Bold) {
        self.textColor = .black
        self.placeholder = placeholder
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font: FontManager.font(font), .foregroundColor: textColor])
    }
}
