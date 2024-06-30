//
//  DebugView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import UIKit
import FlexLayout
import PinLayout

class DebugView: BaseView {

    let tableView = UITableView()
    
    override func configureLayout() {
        
        self.backgroundColor = .black
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        
        flexView.flex.define { flex in
            
            flex.addItem(tableView)
                .width(100%)
                .grow(1)
        }
    }
}
