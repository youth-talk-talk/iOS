//
//  DetailConditionView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/14/24.
//

import UIKit
import FlexLayout

class DetailConditionView: BaseView {
    
    let infoLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: DetailConditionLayout.layout())
    let bottomView = UIView()
    let resetButton = UIButton()
    let applyButton = UIButton()

    override func configureLayout() {
        
        bottomView.addSubview(resetButton)
        bottomView.addSubview(applyButton)
        
        flexView.flex.define { flex in
            
            flex.addItem(infoLabel)
                .width(100%)
                .height(50)
                .alignSelf(.center)
                .backgroundColor(.gray10)
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
            
            flex.addItem(bottomView).define { flex in
                
                flex.addItem(resetButton)
                    .width(50)
                    .height(50)
                    .marginLeft(13)
                    .cornerRadius(25)
                    .backgroundColor(.gray20)
                
                flex.addItem()
                    .width(12)
                
                flex.addItem(applyButton)
                    .height(50)
                    .grow(1)
                    .marginRight(13)
                    .defaultCornerRadius()
            }
            .direction(.row)
            .height(76)
            .width(100%)
            .alignItems(.center)
        }
        
    }

    override func configureView() {
        
        infoLabel.designed(text: "상세조건은 모든 카테고리에 적용됩니다", fontType: .p16Regular16, textColor: .gray60)
        infoLabel.textAlignment = .center
        
        let title = "초기화"
        resetButton.designedCategoryLayout(title: title, image: .rotateRight)
        var configuration = resetButton.configuration
        var attribute = AttributedString.init(title)
        attribute.font = UIFont.systemFont(ofSize: 10)
        
        configuration?.attributedTitle = attribute
        configuration?.imagePadding = 0
        configuration?.titlePadding = 0
        configuration?.titleAlignment = .center
        resetButton.configuration = configuration
        
        applyButton.designed(title: "적용하기", withAction: true)
        applyButton.isEnabled = false
    }
}
