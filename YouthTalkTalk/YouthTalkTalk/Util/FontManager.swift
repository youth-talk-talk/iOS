//
//  FontManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/11/24.
//

import UIKit

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

enum TextColor {
    
    var value: UIColor {
        
        switch self {
        case .lightGray:
            
            return .customLightGray
        case .semiLightGray:
            
            return .semiLightGray
        case .baseGray:
            
            return .baseGray
        case .midGray:
            
            return .midGray
        case .semiDarkGray:
            
            return .semiDarkGray
        case .darkGray:
            
            return .customDarkGray
        }
    }
    
    case lightGray
    case semiLightGray
    case baseGray
    case midGray
    case semiDarkGray
    case darkGray
}
