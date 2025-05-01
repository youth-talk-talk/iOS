//
//  PolicyView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/24/24.
//

import UIKit
import FlexLayout
import PinLayout

class PolicyView: BaseView {
    
    // 제거

    let tableview = UITableView()
    // TODO: 추후 댓글추가
//    let commentTextfield = UITextField()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(tableview)
                .grow(1)
                .width(90%)
                .alignSelf(.center)
                .markDirty()
                .backgroundColor(.clear)
//            
//            flex.addItem(commentTextfield)
//                .height(50)
//                .width(90%)
//                .alignSelf(.center)
//                .backgroundColor(.gray10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.flex.layout()
    }
}
