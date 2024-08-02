//
//  BaseTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseTableViewCell: UITableViewCell {

    let flexView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(flexView)
        
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
        flexView.flex.layout(mode: .adjustHeight)
    }
}
