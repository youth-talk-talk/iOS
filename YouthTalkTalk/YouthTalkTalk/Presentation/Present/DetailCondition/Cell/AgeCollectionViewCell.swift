//
//  AgeCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/15/24.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa

class AgeCollectionViewCell: BaseCollectionViewCell {
    
    let fullLabel = UILabel()
    let ageTextField = UITextField()
    let ageLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(fullLabel)
            
            flex.addItem(ageTextField)
                .height(45)
                .width(145)
                .marginLeft(12)
                .defaultCornerRadius()
                .border(1, .gray40)
            
            flex.addItem(ageLabel)
                .marginLeft(12)
                .grow(1)
                
        }
        .direction(.row)
        .alignItems(.center)
    }
    
    override func configureView() {
        
        fullLabel.designed(text: "만", fontType: .p16Regular16, textColor: .gray40)
        ageLabel.designed(text: "세", fontType: .p16Regular16, textColor: .gray40)
        
        ageTextField.textAlignment = .center
    }
}
