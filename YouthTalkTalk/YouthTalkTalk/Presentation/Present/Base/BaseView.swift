//
//  BaseView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseView: UIView {

    let flexView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(flexView)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.pin.all(self.pin.safeArea)
        flexView.flex.layout()
    }
    
    func configureLayout() {}
    func configureView() {}
    
    // deinit {
    //     print(String(describing: type(of: self)))
    // }
}
