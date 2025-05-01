//
//  GrabView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class GrabView: UIView {
    init() {
        
        let width: CGFloat = 50
        let height: CGFloat = 4
        
        super.init(frame: .init(x: (UIScreen.main.bounds.width - width) / 2,
                                y: 10,
                                width: width,
                                height: height))
        
        backgroundColor = .gray50
        layer.cornerRadius = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
