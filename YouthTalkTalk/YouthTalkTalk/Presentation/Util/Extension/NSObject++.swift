//
//  NSObject++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import Foundation
import UIKit

extension NSObject {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}

private let guidelineBaseWidth: CGFloat = 375.0
private let guidelineBaseHeight: CGFloat = 812.0

public func scale(number: CGFloat) -> CGFloat {
    let screenWidth: CGFloat

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        screenWidth = window.bounds.width
    } else {
        screenWidth = UIScreen.main.bounds.width
    }

    return (screenWidth / guidelineBaseWidth) * number
}

public func moderate(_ number: CGFloat) -> CGFloat {
    number + (scale(number: number) - number) * 0.5
}
