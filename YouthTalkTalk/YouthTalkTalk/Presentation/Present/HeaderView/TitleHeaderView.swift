//
//  TitleHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

final class TitleHeaderView: BaseCollectionReusableView {
        
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginTop(15)
                .marginBottom(12)
        }
    }
    
    func setTitle(_ title: String) {
        
        titleLabel.designed(text: title, fontType: .g14Bold, textColor: .gray60)
    }
}
