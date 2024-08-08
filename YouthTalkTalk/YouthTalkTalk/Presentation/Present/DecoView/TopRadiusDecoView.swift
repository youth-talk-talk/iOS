//
//  TopRadiusDecoView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit

final class TopRadiusDecoView: BaseCollectionReusableView {
 
    override func configureView() {
        backgroundColor = .gray10
        
        layer.cornerRadius = 20
        layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        layer.masksToBounds = true
    }
}
