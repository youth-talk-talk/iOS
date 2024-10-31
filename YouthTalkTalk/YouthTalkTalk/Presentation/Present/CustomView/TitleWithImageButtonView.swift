//
//  TitleWithImageButtonView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import UIKit
import FlexLayout
import PinLayout

final class TitleWithImageButtonView: BaseView {
    
    private let titleLabel = UILabel()
    let imageButton = UIButton()
    
    override func configureView() {
        
        flexView.layer.cornerRadius = 8
        flexView.layer.borderColor = UIColor.gray30.cgColor
        flexView.layer.masksToBounds = true
        flexView.layer.borderWidth = 1
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginLeft(14)
                .alignSelf(.center)
                .grow(1)
            
            flex.addItem(imageButton)
                .size(24)
                .marginRight(12)
                .alignSelf(.center)
        }
        .direction(.row)
        .height(50)
    }
    
    func setTitle(_ title: String) {
        
        titleLabel.designed(text: title, fontType: .p16Regular24, textColor: .black)
    }
    
    func setImage(_ image: UIImage) {
        
        imageButton.setImage(image, for: .normal)
    }
}
