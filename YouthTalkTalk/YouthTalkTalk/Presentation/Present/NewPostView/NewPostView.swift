//
//  NewPostView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import UIKit
import FlexLayout
import PinLayout

class NewPostView: BaseView {

    let titleLabel = UILabel()
    let titleTextField = UITextField()
    
    let policyView = UIView()
    let policyLabel = UILabel()
    let policySearchButton = TitleImageSpacingView()
    
    let contentsLabel = UILabel()
    let contentsTextView = UITextView()
    
    let addImageButton = UIButton()
    let registrationButton = UIButton()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
         
            // 제목 라인
            flex.addItem().define { flex in
                
                flex.addItem(titleLabel)
                    .width(41)
                
                flex.addItem(titleTextField)
                    .marginLeft(13)
                    .defaultCornerRadius()
                    .grow(1)
                    .border(1, .gray20)
            }
            .height(50)
            .direction(.row)
            .marginHorizontal(5%)
            
            // 정책명 라인
            flex.addItem(policyView).define { flex in
                
                flex.addItem(policyLabel)
                    .width(41)
                
                flex.addItem(policySearchButton)
                    .marginLeft(13)
                    .defaultCornerRadius()
                    .grow(1)
                    .border(1, .gray20)
            }
            .marginTop(12)
            .height(50)
            .direction(.row)
            .marginHorizontal(5%)
            
            // 내용작성
            flex.addItem(contentsLabel)
                .marginTop(24)
                .marginHorizontal(5%)
            
            flex.addItem(contentsTextView)
                .marginTop(13)
                .marginHorizontal(5%)
                .grow(1)
                .defaultCornerRadius()
                .border(1, .gray20)
            
            // 사진 추가 버튼
            flex.addItem(addImageButton)
                .marginTop(13)
                .marginHorizontal(5%)
                .height(50)
                .defaultCornerRadius()
            
            // 등록 버튼
            flex.addItem(registrationButton)
                .marginTop(6)
                .marginHorizontal(5%)
                .height(50)
                .defaultCornerRadius()
                .marginBottom(12)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "제목", fontType: .p16SemiBold, textColor: .black)
        titleTextField.designedPlaceholder(placeholder: "제목을 작성해주세요", textColor: .gray50, font: .p16Regular16)
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: titleTextField.frame.height))
        titleTextField.leftViewMode = .always
        
        policyLabel.designed(text: "정책명", fontType: .p16SemiBold, textColor: .black)
        
        contentsLabel.designed(text: "내용 작성", fontType: .p16SemiBold, textColor: .black)
        
        addImageButton.designed(title: "사진 추가하기", titleColor: .black, fontType: .p16Regular16)
        registrationButton.designed(title: "등록하기", titleColor: .black, bgColor: .gray20, fontType: .p16Regular16)
    }
}
