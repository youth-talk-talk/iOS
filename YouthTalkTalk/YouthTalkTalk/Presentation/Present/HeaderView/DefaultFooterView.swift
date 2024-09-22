//
//  DefaultFooterView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/22/24.
//

import UIKit
import FlexLayout

class DefaultFooterView: BaseCollectionReusableView {
    
    let containerView = UIView()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(containerView)
                .width(100%)
                .height(30)
        }
    }
        
}
