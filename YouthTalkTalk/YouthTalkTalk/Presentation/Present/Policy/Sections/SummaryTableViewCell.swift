//
//  SummaryTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import PinLayout
import FlexLayout

class SummaryTableViewCell: BaseTableViewCell {
    
    let hostDepLabel = UILabel()
    let titleLabel = UILabel()
    let introduceLabel = UILabel()
    
    let rightImageView = UIImageView()
    let sectionTitleLabel = UILabel()
    
    let supportDetailTitleLabel = UILabel()
    let supportDetailLabel = UILabel()
    
    let applyTermTitleLabel = UILabel()
    let applyTermLabel = UILabel()
    
    let operationTermTitleLabel = UILabel()
    let operationTermLabel = UILabel()
    
    var onHeightChange: (() -> Void)?
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(hostDepLabel)
                .marginTop(4)
            
            flex.addItem(titleLabel)
                .marginTop(4)
            
            flex.addItem(introduceLabel)
            
            flex.addItem().define { flex in
                
                flex.addItem(rightImageView)
                    .size(24)
                    .marginLeft(0)
                
                flex.addItem(sectionTitleLabel)
                    .marginLeft(4)
                
            }
            .direction(.row)
            .marginTop(12)
            
            flex.addItem().define { flex in
                
                flex.addItem(supportDetailTitleLabel)
                
                flex.addItem(supportDetailLabel)
                    .marginTop(4)
                
                flex.addItem(applyTermTitleLabel)
                    .marginTop(12)
                
                flex.addItem(applyTermLabel)
                    .marginTop(4)
                
                flex.addItem(operationTermTitleLabel)
                    .marginTop(12)
                
                flex.addItem(operationTermLabel)
                    .marginTop(4)
            }
            .direction(.column)
            .marginTop(12)
        }
    }
    
    override func configureView() {
        
        rightImageView.image = UIImage.right
        
        sectionTitleLabel.designed(text: "한눈에 보는 정책 요약", fontType: .p18Bold, textColor: .black)
        
        supportDetailTitleLabel
            .designed(text: "지원내용", fontType: .p14Regular, textColor: .gray50, applyLineHeight: false)
        
        applyTermTitleLabel
            .designed(text: "신청기간", fontType: .p14Regular, textColor: .gray50, applyLineHeight: false)
        
        operationTermTitleLabel
            .designed(text: "운영기간", fontType: .p14Regular, textColor: .gray50, applyLineHeight: false)
    }
    
    func configure(_ data: DetailPolicyEntity.PolicySummary) {
        
        hostDepLabel.designed(text: data.hostDep ?? "-", fontType: .p14Bold, textColor: .gray50)
        
        titleLabel.designed(text: data.title, fontType: .p24Bold, textColor: .black, applyLineHeight: false)
        titleLabel.numberOfLines = 0
        
        introduceLabel.designed(text: data.introduction ?? "-", fontType: .p14Bold, textColor: .gray50, applyLineHeight: false)
        introduceLabel.numberOfLines = 0
        
        supportDetailLabel
            .designed(text: data.supportDetail ?? "-", fontType: .p14Bold, textColor: .black, applyLineHeight: false)
        supportDetailLabel.numberOfLines = 0
        
        applyTermLabel
            .designed(text: data.applyTerm ?? "-", fontType: .p14Bold, textColor: .black, applyLineHeight: false)
        
        if let operationTerm = data.operationTerm, operationTerm != "null" {
            operationTermLabel
                .designed(text: operationTerm, fontType: .p14Bold, textColor: .black, applyLineHeight: false)
        } else {
            operationTermLabel
                .designed(text: "-", fontType: .p14Bold, textColor: .black, applyLineHeight: false)
        }
        
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    fileprivate func layout() {
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return flexView.frame.size
    }
}
