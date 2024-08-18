//
//  TitleImageSpacingView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/13/24.
//

import UIKit
import FlexLayout
import PinLayout

class TitleImageSpacingView: BaseView {
    
    let titleLabel = UILabel()
    let iconImageView = UIImageView()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginLeft(20)
                .grow(1)
                .alignSelf(.center)
            
            flex.addItem(iconImageView)
                .marginRight(20)
                .alignSelf(.center)
                .width(24)
                .height(24)
        }
        .direction(.row)
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "정책명을 검색해주세요", fontType: .p16Regular16, textColor: .gray50)
        iconImageView.image = .magnifyingglass
    }
}
