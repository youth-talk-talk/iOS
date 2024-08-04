//
//  DetailTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import PinLayout
import FlexLayout

class DetailTableViewCell: BaseTableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    fileprivate func layout() {
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return flexView.frame.size
    }
}
