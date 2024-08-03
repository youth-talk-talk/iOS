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

    let tableview = UITableView()
    let commentTextfield = UITextField()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(tableview)
                .grow(1)
                .width(90%)
                .alignSelf(.center)
                .markDirty()
                .backgroundColor(.clear)
            
            flex.addItem(commentTextfield)
                .height(50)
                .width(90%)
                .alignSelf(.center)
                .backgroundColor(.gray10)
        }
    }

}
