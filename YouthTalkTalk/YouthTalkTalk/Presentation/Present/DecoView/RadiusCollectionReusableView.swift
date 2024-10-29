//
//  RadiusCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit

final class RadiusCollectionReusableView: BaseCollectionReusableView {
        
    override func configureView() {
        backgroundColor = .gray10
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}
