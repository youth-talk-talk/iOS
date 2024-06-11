//
//  FontManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/11/24.
//

import UIKit

final class FontManager {
    
    static let shared = FontManager()
    
    private init() { }
    
    func setFont() {
        
    }
}

enum FontType {
 
    case titleForPolicySemibold
    case titleForPolicyRegular
    
    case titleForAppBold
    case titleForAppRegular
    
    case titleForNormalSemiBold
    case titleForNormalRegular
    
    case subTitleForPolicyBold
    case subTitleForPolicyRegular
    
    case bodyBold
    case bodyRegular
    
    case bodyForCategorySemibold
    
    case bodyForPolicyBold
    case bodyForPolicyRegular
    
    case bodyForTermsSemibold
    case bodyForTermsRegular
}
