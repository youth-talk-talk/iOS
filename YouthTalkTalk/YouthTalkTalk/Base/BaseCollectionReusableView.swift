//
//  BaseCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout
import PinLayout

class BaseCollectionReusableView: UICollectionReusableView {
    
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
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        flexView.flex.layout(mode: .adjustHeight)
        
        return flexView.frame.size
    }
    
    func configureLayout() {}
    func configureView() {}
}
