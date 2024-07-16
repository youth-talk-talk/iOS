//
//  PopularCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

final class PopularCollectionViewCell: BaseCollectionViewCell {
    
    let regionLabel = UILabel()
    let policyTitleLabel = UILabel()
    let categoryLabel = UILabel()
    let bookmarkButton = UIButton()
    
    override func configureLayout() {
        
        [policyTitleLabel, categoryLabel, bookmarkButton].forEach { flexView.addSubview($0) }
        
        flexView.flex.define { flex in
            
            flex.addItem(regionLabel)
                .marginTop(15)
                .marginHorizontal(11)
            
            flex.addItem(policyTitleLabel)
                .marginTop(1)
                .marginHorizontal(11)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem().define { flex in
            
                flex.addItem(categoryLabel)
                flex.addItem(bookmarkButton)
                    .height(24)
                    .width(24)
            }
            .direction(.row)
            .marginBottom(15)
            .marginHorizontal(11)
            .justifyContent(.spaceBetween)
            
            
        }
    }
    
    override func configureView() {
     
        regionLabel.designed(text: "지역", fontType: .p12Regular, textColor: .gray60)
        policyTitleLabel.designed(text: "정책명", fontType: .p18Bold, textColor: .black)
        categoryLabel.designed(text: "카테고리", fontType: .p12Bold, textColor: .gray40)
        bookmarkButton.designedByImage(.bookmark)
        
        regionLabel.lineBreakMode = .byTruncatingTail
        policyTitleLabel.numberOfLines = 3
        flexView.backgroundColor = .white
    }
    
    func configure(data: PolicyEntity?) {
        
        guard let data else { return }
        
        regionLabel.text = data.hostDep
        policyTitleLabel.text = data.title
        
        let policyCategory = PolicyCategory(rawValue: data.category) ?? .life
        categoryLabel.text = policyCategory.name
    }
}
