//
//  ChoiceCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/15/24.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa

class ChoiceCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let mainButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(mainButton)
                .width(100%)
                .height(100%)
                .defaultCornerRadius()
                .border(1, .gray40)
        }
    }
    
    override func configureView() {
        
        mainButton.designed(title: "-", titleColor: .black, bgColor: .clear, fontType: .p16Regular16, withAction: true)
    }
}
