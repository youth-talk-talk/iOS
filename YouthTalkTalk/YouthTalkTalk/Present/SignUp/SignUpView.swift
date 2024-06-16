//
//  SignUpView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit
import FlexLayout
import PinLayout

class SignUpView: BaseView {
    
    let nicknameLiteralLabel = UILabel()
    let nicknameTextField = UITextField()
    let nicknameGuidelineLabel = UILabel()
    
    let regionLiteralLabel = UILabel()
    let regionPopupButton = UIButton()
    
    let pullDownTableView = UITableView()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
                
                flex.addItem(nicknameLiteralLabel)
                    .marginTop(30)
                
                flex.addItem(nicknameTextField)
                    .marginTop(7)
                    .defaultCornerRadius()
                    .defaultHeight()
                    .border(1, .gray30)
                
                flex.addItem(nicknameGuidelineLabel)
                
                flex.addItem(regionLiteralLabel)
                    .marginTop(2)
                
                flex.addItem(regionPopupButton)
                    .marginTop(7)
                    .defaultButton()
                    .border(1, .gray30)
            }
            .direction(.column)
            .alignSelf(.center)
            .width(90%)
            
        }
    }
    
    override func configureView() {
        
        nicknameLiteralLabel.designed(text: "닉네임 설정", fontType: .bodyForCategorySemibold)
        nicknameGuidelineLabel.designed(text: "원하는 닉네임이 있는 경우 직접 설정이 가능해요!(단, 한글 8자 이내)", fontType: .bodyForTermsRegular, textColor: .gray40)
        
        // 왼쪽 여백
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nicknameTextField.frame.height))
        nicknameTextField.leftView = leftPadding
        nicknameTextField.leftViewMode = .always
        
        let textPlaceHolder = "씩씩한 청년"
        nicknameTextField.placeholder = textPlaceHolder
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: textPlaceHolder, attributes: [.font: FontManager.font(.bodyBold), .foregroundColor: UIColor.black])
        
        nicknameTextField.font = FontManager.font(.bodyBold)
        
        regionLiteralLabel.designed(text: "지역설정", fontType: .bodyForCategorySemibold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.addSubview(pullDownTableView)
        pullDownTableView.backgroundColor = .clear
        pullDownTableView.layer.cornerRadius = 8
        
        pullDownTableView.pin.below(of: regionPopupButton)
            .horizontally(5%)
        
        pullDownTableView.flex.layout(mode: .adjustHeight)
    }
}
