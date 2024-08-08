//
//  SearchHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit
import FlexLayout
import PinLayout

class SearchHeaderView: BaseCollectionReusableView {
        
    let testView = UIView()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(testView)
                .width(100%)
                .height(100)
                .backgroundColor(.white)
        }
    }
}
