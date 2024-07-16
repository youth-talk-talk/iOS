//
//  BaseCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseCollectionViewCell: UICollectionViewCell {
    
    let flexView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(flexView)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() { }
    
    func configureView() { }
    
    override func layoutSubviews() {
        
        flexView.pin.all()
        flexView.flex.layout()
    }
}
