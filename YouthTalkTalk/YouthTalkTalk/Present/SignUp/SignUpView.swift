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
    let regionDropDownView = DropDownView()
    
    let pullDownTableView = UITableView()
    
    let signUpButton = UIButton()
    
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
                
                flex.addItem(regionDropDownView)
                    .marginTop(7)
            }
            .direction(.column)
            .alignSelf(.center)
            .width(90%)
            
            flex.addItem().grow(1)
            
            flex.addItem(signUpButton)
                .marginBottom(42)
                .defaultButton()
                .alignSelf(.center)
                .width(90%)
        }
    }
    
    override func configureView() {
        
        // Nickname Literal Label
        nicknameLiteralLabel.designed(text: "닉네임 설정", fontType: .bodyForCategorySemibold)
        
        // Nickname Guideline Label
        nicknameGuidelineLabel.designed(text: "원하는 닉네임이 있는 경우 직접 설정이 가능해요!(단, 한글 8자 이내)", fontType: .bodyForTermsRegular, textColor: .gray40)
        
        // NickName TextField
        // 왼쪽 여백
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nicknameTextField.frame.height))
        nicknameTextField.leftView = leftPadding
        nicknameTextField.leftViewMode = .always
        
        let textPlaceHolder = "씩씩한 청년"
        nicknameTextField.placeholder = textPlaceHolder
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: textPlaceHolder, attributes: [.font: FontManager.font(.bodyBold), .foregroundColor: UIColor.black])
        
        nicknameTextField.font = FontManager.font(.bodyBold)
        
        // Region Literal Label
        regionLiteralLabel.designed(text: "지역설정", fontType: .bodyForCategorySemibold)
        
        // Region Dropdown View
        
        // TableView
        pullDownTableView.backgroundColor = .clear
        pullDownTableView.separatorInset = .zero
        pullDownTableView.isHidden = true
        
        // Sign Up Button
        signUpButton.designed(title: "시작하기")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexView.addSubview(pullDownTableView)
        
        pullDownTableView.pin.below(of: regionDropDownView)
            .marginTop(5)
            .horizontally(5%)
            .height(0)
        
        // 셀 갯수에 따른 동적인 높이 설정
        updateTableViewHeight()
    }
    
    func updateLocation(_ location: LocationKR) {
        regionDropDownView.regionDropdownLabel.designed(text: location.korean,
                                                                   fontType: .bodyBold)

        pullDownTableView.isHidden = true
    }
    
    private func updateTableViewHeight() {
        
        // 셀의 높이 계산
        let cellHeight: CGFloat = 44
        
        // 셀의 개수에 따라 TableView의 높이 계산
        let tableViewHeight = CGFloat(pullDownTableView.numberOfRows(inSection: 0)) * cellHeight
        
        // safeArea를 고려하여 최대 높이 설정
        // let maxTableViewHeight = UIScreen.main.bounds.height - safeAreaInsets.top - regionPopupButton.frame.maxY - 100
        let maxTableViewHeight = signUpButton.frame.minY - regionDropDownView.frame.maxY - 55
        
        // TableView의 최종 높이 결정
        let finalTableViewHeight = min(tableViewHeight, maxTableViewHeight)
        
        // TableView의 높이 업데이트
        pullDownTableView.pin.height(finalTableViewHeight)
    }
}
