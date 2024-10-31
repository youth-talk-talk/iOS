//
//  CommentTextFieldView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/19/24.
//

import UIKit
import FlexLayout
import PinLayout

class CommentTextFieldView: BaseView {
    
    let textField = UITextField()
    let rightPaddingView = UIView()
    let commentTap = UITapGestureRecognizer()
    
    override func configureView() {
        
        textField.designedPlaceholder(placeholder: "댓글을 달아보세요", font: .p16Regular16)
        textField.makeLeftPaddingView()
        textField.backgroundColor = .gray10
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        // 이미지 설정
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        // 이미지의 크기 설정
        rightPaddingView.frame = CGRect(x: 0, y: 0, width: 37, height: 24)
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.image = .arrowUp
        
        rightPaddingView.addSubview(imageView)
        rightPaddingView.addGestureRecognizer(commentTap)
        rightPaddingView.isUserInteractionEnabled = true

        // UITextField의 rightView에 이미지 넣기
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always  // 항상 표시
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem()
                .width(100%)
                .height(0.5)
                .backgroundColor(.black.withAlphaComponent(0.2))
            
            flex.addItem(textField)
                .marginHorizontal(17)
                .height(50)
            
            flex.addItem()
                .width(100%)
                .height(0.5)
                .backgroundColor(.black.withAlphaComponent(0.2))
        }
        .justifyContent(.spaceBetween)
    }
}
