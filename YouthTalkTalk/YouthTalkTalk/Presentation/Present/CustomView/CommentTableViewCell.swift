//
//  CommentTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import UIKit
import FlexLayout
import PinLayout

class CommentTableViewCell: BaseTableViewCell {
    
    let nicknameLabel = UILabel()
    let commentLabel = UILabel()
    
    override func configureView() {
        
        flexView.backgroundColor = .white
        
        flexView.layer.cornerRadius = 4
        flexView.layer.masksToBounds = true
        flexView.layer.borderColor = UIColor.black.cgColor
        flexView.layer.borderWidth = 1
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(nicknameLabel)
                .width(100%)
            
            flex.addItem(commentLabel)
                .width(100%)
        }
    }
    
    func configure(_ data: CommentDetailEntity) {
        
        nicknameLabel.designed(text: data.nickname, fontType: .p12Bold)
        
        commentLabel.designed(text: data.content, fontType: .p12Regular)
        commentLabel.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = flexView.subviews.reduce(0) { partialResult, view in
            return partialResult + view.frame.height
        }
        
        flexView.flex.height(height)
        flexView.flex.layout(mode: .adjustHeight)
    }
}
