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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        regionLabel.designed(text: "", fontType: .p12Regular, textColor: .gray60)
        policyTitleLabel.designed(text: "", fontType: .p18Bold, textColor: .black)
        categoryLabel.designed(text: "", fontType: .p12Bold, textColor: .gray40)
    }
    
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
                    .grow(1)
                flex.addItem(bookmarkButton)
                    .height(24)
                    .width(24)
            }
            .direction(.row)
            .marginBottom(15)
            .marginHorizontal(11)
            .justifyContent(.spaceBetween)
        }
        .direction(.column)
    }
    
    override func configureView() {
        
        regionLabel.lineBreakMode = .byTruncatingTail
        policyTitleLabel.numberOfLines = 3
        flexView.backgroundColor = .white
    }
    
    func configure(data: PolicyEntity?) {
        
        guard let data else { return }
        
        let policyCategory = PolicyCategory(rawValue: data.category) ?? .life
        
        regionLabel.designed(text: data.hostDep, fontType: .p12Regular, textColor: .gray60)
        policyTitleLabel.designed(text: data.title, fontType: .p18Bold, textColor: .black)
        categoryLabel.designed(text: policyCategory.name, fontType: .p12Bold, textColor: .gray40)
        bookmarkButton.designedByImage(.bookmark)
        
        if policyTitleLabel.frame.height != 0 {
            updatePolicyLabelHeight()
        }
        
    }
    
    private func updatePolicyLabelHeight() {
        
        let textWidth = policyTitleLabel.calculateWidth(for: policyTitleLabel.frame.height)
        let labelWidth = policyTitleLabel.frame.width
        let line = textWidth / labelWidth
        
        if line < 1 {
            policyTitleLabel.flex.height(24)
        } else if line >= 1, line < 2 {
            policyTitleLabel.flex.height(48)
        } else if line >= 2 {
            policyTitleLabel.flex.height(72)
        }
    }
}
