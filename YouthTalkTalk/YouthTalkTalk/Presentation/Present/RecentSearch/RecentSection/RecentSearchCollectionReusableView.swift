//
//  RecentSearchCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/17/24.
//

import UIKit
import FlexLayout
import PinLayout

class RecentSearchCollectionReusableView: BaseCollectionReusableView {
 
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginTop(12)
                .marginBottom(8)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "최근검색", fontType: .p14Bold, textColor: .gray60)
    }
}
