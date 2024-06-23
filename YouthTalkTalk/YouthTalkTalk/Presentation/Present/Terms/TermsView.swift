//
//  TermsView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/15/24.
//

import UIKit
import FlexLayout

final class TermsView: BaseView {
    
    let commentLabel = UILabel()
    let subcommentLabel = UILabel()
    
    let cancelButton = UIButton()
    let confirmButton = UIButton()

    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            // 약관 내용이 들어갈 곳
            flex.addItem().grow(1)
            
            flex.addItem().define { flex in
                
                flex.addItem(commentLabel)
                
                flex.addItem(subcommentLabel)
                
                // 버튼 영역
                flex.addItem().define { flex in
                    
                    flex.addItem(cancelButton)
                        .defaultButton()
                        .maxWidth(45%)
                        .grow(1)
                    
                    flex.addItem(confirmButton)
                        .defaultButton()
                        .maxWidth(45%)
                        .grow(1)
                    
                }
                .direction(.row)
                .justifyContent(.center)
                .width(90%)
                .columnGap(16)
                .marginTop(14)
                .marginBottom(21)
            }
            .direction(.column)
            .alignItems(.center)
        }
    }

    override func configureView() {
        
        backgroundColor = .white
        
        commentLabel.designed(text: "청년톡톡 서비스 약관에 동의하시겠습니까?", fontType: .p14Bold)
        subcommentLabel.designed(text: "약관 미동의 시 서비스 이용이 불가합니다", fontType: .p12Regular, textColor: .gray40)
        
        cancelButton.designed(title: "아니요", bgColor: .gray20)
        confirmButton.designed(title: "예")
    }
}
