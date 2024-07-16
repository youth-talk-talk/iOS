//
//  RecentCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit

final class RecentCollectionViewCell: BaseCollectionViewCell {

    let regionLabel = UILabel()
    let deadlineLabel = UILabel()
    let policyTitleLabel = UILabel()
    let categoryLabel = UILabel()
    let bookmarkButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        regionLabel.text = ""
        deadlineLabel.text = ""
        policyTitleLabel.text = ""
        categoryLabel.text = ""
    }
    
    override func configureLayout() {
        
        [policyTitleLabel, categoryLabel, bookmarkButton].forEach { flexView.addSubview($0) }
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
            
                flex.addItem(regionLabel)
                    .grow(1)
                flex.addItem(deadlineLabel)
                    .grow(1)
            }
            .direction(.row)
            .marginHorizontal(11)
            .justifyContent(.spaceBetween)
            
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
            .marginHorizontal(11)
            .justifyContent(.spaceBetween)
        }
        .paddingVertical(13)
    }
    
    override func configureView() {
     
        regionLabel.designed(text: "지역", fontType: .p12Regular, textColor: .gray60)
        deadlineLabel.designed(text: "", fontType: .p16SemiBold, textColor: .gray40)
        policyTitleLabel.designed(text: "정책명", fontType: .p18Bold, textColor: .black)
        categoryLabel.designed(text: "카테고리", fontType: .p12Bold, textColor: .gray40)
        bookmarkButton.designedByImage(.bookmark)
        
        regionLabel.lineBreakMode = .byTruncatingTail
        policyTitleLabel.lineBreakMode = .byTruncatingTail
        
        deadlineLabel.textAlignment = .right
        
        flexView.backgroundColor = .white
    }
    
    func configure(data: PolicyEntity?) {
        
        guard let data else { return }
        
        regionLabel.text = data.hostDep
        policyTitleLabel.text = data.title
        deadlineLabel.text = data.deadlineStatus
        
        let policyCategory = PolicyCategory(rawValue: data.category) ?? .life
        categoryLabel.text = policyCategory.name
    }
}
