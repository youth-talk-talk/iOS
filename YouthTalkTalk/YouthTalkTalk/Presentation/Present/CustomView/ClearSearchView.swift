//
//  ClearSearchView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

import UIKit
import FlexLayout
import PinLayout

final class ClearSearchView: BaseView {
    
    let magnifyingglassButton = UIButton()
    let textField = UITextField()
    let cancelButton = UIButton()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(magnifyingglassButton)
                .height(24)
                .width(24)
                .alignSelf(.center)
                .marginLeft(20)
            
            flex.addItem(textField)
                .height(44)
                .marginLeft(6)
                .grow(1)
            
            flex.addItem(cancelButton)
                .height(24)
                .width(24)
                .alignSelf(.center)
                .marginRight(20)
        }
        .direction(.row)
        .defaultCornerRadius()
    }
    
    override func configureView() {
        
        flexView.backgroundColor = .gray10
        
        flexView.addSubview(magnifyingglassButton)
        flexView.addSubview(textField)
        flexView.addSubview(cancelButton)
        
        let magnifyingglassImage = UIImage.magnifyingglass
        magnifyingglassImage.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        magnifyingglassButton.designedByImage(magnifyingglassImage)
        
        let cancelImage = UIImage.xmark
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .black)
        cancelImage.withTintColor(.black, renderingMode: .alwaysOriginal)
        cancelImage.withConfiguration(imageConfiguration)
        
        cancelButton.designedByImage(cancelImage)
        
        let placeHolder = "검색"
        textField.placeholder = placeHolder
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.font: FontManager.font(.p16Regular24), .foregroundColor: UIColor.gray50])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
}
