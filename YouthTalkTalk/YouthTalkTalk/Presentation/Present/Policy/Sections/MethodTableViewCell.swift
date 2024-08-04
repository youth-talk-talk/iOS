//
//  MethodTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit

class MethodTableViewCell: BaseTableViewCell {

    
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
