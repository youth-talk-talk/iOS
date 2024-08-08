//
//  PopularHeaderReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

final class PopularHeaderReusableView: BaseCollectionReusableView {
        
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginTop(15)
                .marginBottom(12)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "인기정책", fontType: .g14Bold, textColor: .gray60)
    }
}
