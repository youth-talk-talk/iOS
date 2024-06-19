//
//  CategoryCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout

class CategoryCollectionReusableView: BaseCollectionReusableView {
    
    let searchView = UISearchBar()
    
    override func configureLayout() {
        
        flexView.addSubview(searchView)
        
        flexView.flex.define { flex in
            
            flex.addItem(searchView)
                .defaultCornerRadius()
                .defaultHeight()
        }
        .backgroundColor(.gray50)
    }
    
    override func configureView() {
        
        searchView.layer.borderWidth = 1
        searchView.placeholder = "!23"
    }
}
