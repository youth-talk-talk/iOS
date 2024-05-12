//
//  BaseView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
}

extension BaseView {
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
