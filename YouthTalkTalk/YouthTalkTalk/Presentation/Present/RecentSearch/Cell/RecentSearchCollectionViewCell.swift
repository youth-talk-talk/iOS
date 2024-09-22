//
//  RecentSearchCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/9/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let tapGesture = UITapGestureRecognizer()
    let removeButton = UIButton()
    let titleLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.designed(text: "", fontType: .p14Bold, textColor: .black)
        
        disposeBag = DisposeBag()
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(removeButton)
                .height(16)
                .width(16)
                .marginLeft(13)
                .alignSelf(.center)
            
            flex.addItem(titleLabel)
                .marginLeft(8)
                .marginRight(13)
                .grow(1)
            
        }
        .direction(.row)
        .border(1, .lime40)
        .defaultCornerRadius()
    }
    
    override func configureView() {
        
        removeButton.designedByImage(.littleXmark)
        
        titleLabel.designed(text: "", fontType: .p14Bold, textColor: .black)
        
        self.addGestureRecognizer(tapGesture)
    }
    
    func configure(title: String) {
        
        titleLabel.designed(text: title, fontType: .p14Bold, textColor: .black)
        
        flexView.flex.layout(mode: .adjustWidth)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return flexView.frame.size
    }
}
