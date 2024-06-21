//
//  CategoryCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout
import PinLayout

class CategoryCollectionReusableView: BaseCollectionReusableView {
    
    let gradientView = UIView()
    
    let searchBar = UISearchBar()
    let jobImageView = UIImageView()
    
    override func configureLayout() {
        
        flexView.addSubview(gradientView)
        flexView.addSubview(searchBar)
        
        flexView.flex.define { flex in
            
            flex.addItem(gradientView)
                .position(.absolute)
                .top(0)
                .horizontally(0)
                .backgroundColor(.customGreen)
            
            flex.addItem(searchBar)
                .defaultCornerRadius()
                .defaultHeight()
                .marginTop(16)
                .border(1, .gray20)
                .width(90%)
        }
        .alignItems(.center)
    }
    
    override func configureView() {
        
        flexView.backgroundColor = .clear
        
        gradientView.layer.cornerRadius = 20
        gradientView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        gradientView.layer.masksToBounds = true
        
        searchBar.layer.masksToBounds = true
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white.withAlphaComponent(0.95)
        searchBar.searchTextField.leftView?.tintColor = .lime40
        
        if let textfieldBackgroundView = searchBar.searchTextField.subviews.first {
            textfieldBackgroundView.isHidden = true
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let height = searchBar.frame.maxY - (Flex.defaultHeight / 2)
        
        gradientView.flex.height(height)
        flexView.flex.layout(mode: .adjustHeight)
        
        return flexView.frame.size
    }
}
