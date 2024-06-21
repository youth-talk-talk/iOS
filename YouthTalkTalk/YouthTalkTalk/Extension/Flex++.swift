//
//  Flex++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import Foundation
import FlexLayout

extension Flex {
    
    static var defaultHeight: CGFloat {
        return 48
    }
    
    @discardableResult
    func defaultCornerRadius(_ radius: CGFloat = 8) -> Flex {
        
        self.cornerRadius(radius)
    }
    
    @discardableResult
    func defaultHeight(_ height: CGFloat = defaultHeight) -> Flex {
        
        self.height(height)
    }
    
    @discardableResult
    func defaultButton() -> Flex {
        
        self.defaultHeight()
            .defaultCornerRadius()
    }
    
    @discardableResult
    func signInButton() -> Flex {
        
        self.height(54)
            .defaultCornerRadius()
            .alignSelf(.center)
            .width(100%)
    }
}
