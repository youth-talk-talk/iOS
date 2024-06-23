//
//  RecentHeaderReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit
import FlexLayout
import PinLayout

final class RecentHeaderReusableView: BaseCollectionReusableView {
    
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginTop(24)
                .marginBottom(12)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "최근 업데이트", fontType: .sectionHeaderBold, textColor: .gray60)
    }
}
