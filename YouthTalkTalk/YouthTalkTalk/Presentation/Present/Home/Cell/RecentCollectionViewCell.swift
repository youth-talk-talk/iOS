//
//  RecentCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit
import PinLayout
import FlexLayout

final class RecentCollectionViewCell: BaseCollectionViewCell {

    let subTitleLabel = UILabel()
    let deadlineLabel = UILabel()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let scrapButton = UIButton()
    let scrapLabel = UILabel()
    let commentsButton = UIButton()
    let commentsLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subTitleLabel.text = ""
        deadlineLabel.text = ""
        titleLabel.text = ""
        categoryLabel.text = ""
        scrapLabel.text = ""
        commentsLabel.text = ""
    }
    
    override func configureLayout() {
        
        [titleLabel, categoryLabel, scrapButton].forEach { flexView.addSubview($0) }
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
            
                flex.addItem(subTitleLabel)
                    .grow(1)
                    .markDirty()
                flex.addItem(deadlineLabel)
                    .grow(1)
                    .markDirty()
            }
            .direction(.row)
            .marginHorizontal(11)
            .justifyContent(.spaceBetween)
            
            flex.addItem(titleLabel)
                .marginTop(1)
                .marginHorizontal(11)
                .markDirty()
            
            flex.addItem()
                .grow(1)
            
            flex.addItem().define { flex in
                
                flex.addItem(categoryLabel)
                    .grow(1)
                    .markDirty()
                
                flex.define { flex in
                    flex.addItem()
                        .grow(1)
                    
                    flex.addItem(scrapButton)
                        .height(24)
                        .width(24)
                        .markDirty()
                    flex.addItem(scrapLabel)
                        .marginLeft(2)
                        .markDirty()
                    flex.addItem(commentsButton)
                        .height(24)
                        .width(24)
                        .marginLeft(6)
                        .markDirty()
                    flex.addItem(commentsLabel)
                        .marginLeft(2)
                        .markDirty()
                }
                .direction(.row)
            }
            .direction(.row)
            .marginHorizontal(11)
        }
        .paddingVertical(13)
    }
    
    override func configureView() {
     
        subTitleLabel.designed(text: "지역", fontType: .p12Regular, textColor: .gray60)
        deadlineLabel.designed(text: "", fontType: .p16SemiBold, textColor: .gray40)
        titleLabel.designed(text: "정책명", fontType: .p18Bold, textColor: .black)
        categoryLabel.designed(text: "카테고리", fontType: .p12Bold, textColor: .gray40)
        scrapButton.designedByImage(.bookmark)
        commentsButton.designedByImage(.comments)
        
        subTitleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.lineBreakMode = .byTruncatingTail
        
        deadlineLabel.textAlignment = .right
        
        flexView.backgroundColor = .white
    }
    
    func configure(data: PolicyEntity?) {
        
        guard let data else { return }
        
        subTitleLabel.text = data.hostDep
        titleLabel.text = data.title
        deadlineLabel.text = data.deadlineStatus
        
        let policyCategory = PolicyCategory(rawValue: data.category) ?? .life
        categoryLabel.text = policyCategory.name
        
        scrapLabel.text = ""
        commentsLabel.text = ""
        commentsButton.configuration?.image = nil
        scrapLabel.flex.display(.none)
        commentsButton.flex.display(.none)
        commentsLabel.flex.display(.none)
    }
    
    func configure(data: RPEntity?) {
        guard let data else { return }
        
        subTitleLabel.text = data.policyTitle
        titleLabel.text = data.title
        scrapLabel.designed(text: String(data.scraps), fontType: .p14Regular)
        commentsLabel.designed(text: String(data.comments), fontType: .p14Regular)
        
        deadlineLabel.text = ""
        categoryLabel.text = ""
        deadlineLabel.flex.display(.none)
        categoryLabel.flex.display(.none)
    }
}
