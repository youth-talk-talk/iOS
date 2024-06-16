//
//  Flex++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import Foundation
import FlexLayout

extension Flex {
    
    @discardableResult
    func defaultButtonCornerRadius(_ radius: CGFloat = 8) -> Flex {
        
        self.cornerRadius(radius)
    }
    
    @discardableResult
    func defaultButtonHeight(_ height: CGFloat = 48) -> Flex {
        
        self.height(height)
    }
    
    @discardableResult
    func defaultButton() -> Flex {
        
        self.defaultButtonHeight()
            .defaultButtonCornerRadius()
    }
    
    @discardableResult
    func signInButton() -> Flex {
        
        self.height(54)
            .defaultButtonCornerRadius()
            .alignSelf(.center)
            .width(100%)
    }
}
