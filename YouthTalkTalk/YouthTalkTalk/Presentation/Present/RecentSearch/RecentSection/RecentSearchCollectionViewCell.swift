//
//  RecentSearchCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/9/24.
//

import UIKit
import FlexLayout
import PinLayout

class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    
    let flexView = UIView()
    
    override func configureView() {
        
        flexView.backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.pin.all()
        flexView.flex.layout()
    }
}
