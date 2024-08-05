//
//  MethodTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import FlexLayout
import PinLayout

class MethodTableViewCell: BaseTableViewCell {
    
    let questionMarkImageView = UIImageView()
    let sectionTitleLabel = UILabel()
    
    let applStepFlexView = UIView()
    let applStepTitleLabel = UILabel()
    let applStepLabel = UILabel()
    
    let evaluationFlexView = UIView()
    let evaluationTitleLabel = UILabel()
    let evaluationLabel = UILabel()
    
    let applUrlFlexView = UIView()
    let applUrlTitleLabel = UILabel()
    let applUrlLabel = UILabel()
    
    let submitDocFlexView = UIView()
    let submitDocTitleLabel = UILabel()
    let submitDocLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
                
                flex.addItem(questionMarkImageView)
                    .size(24)
                    .marginLeft(0)
                
                flex.addItem(sectionTitleLabel)
                    .marginLeft(4)
            }
            .direction(.row)
            .marginTop(24)
            
            // 신청절차
            addItemLine(flex: flex, flexView: applStepFlexView, titleLabel: applStepTitleLabel, contentLabel: applStepLabel)
                .marginTop(12)
            
            // 심사 및 발표
            addItemLine(flex: flex, flexView: evaluationFlexView, titleLabel: evaluationTitleLabel, contentLabel: evaluationLabel)
                .marginTop(4)
            
            // 신청 사이트
            addItemLine(flex: flex, flexView: applUrlFlexView, titleLabel: applUrlTitleLabel, contentLabel: applUrlLabel)
                .marginTop(4)
            
            // 제출 서류
            addItemLine(flex: flex, flexView: submitDocFlexView, titleLabel: submitDocTitleLabel, contentLabel: submitDocLabel)
                .marginTop(4)
        }
    }
    
    override func configureView() {
        
        questionMarkImageView.image = UIImage.questionMark
        
        sectionTitleLabel.designed(text: "신청방법이 궁금해요", fontType: .p18Bold, textColor: .black)
        
        applStepTitleLabel.designed(text: "신청절차", fontType: .p16SemiBold, textColor: .gray50)
        evaluationTitleLabel.designed(text: "심사 및 발표", fontType: .p16SemiBold, textColor: .gray50)
        applUrlTitleLabel.designed(text: "신청 사이트", fontType: .p16SemiBold, textColor: .gray50)
        submitDocTitleLabel.designed(text: "제출 서류", fontType: .p16SemiBold, textColor: .gray50)
    }
    
    func configure(_ data: DetailPolicyEntity.PolicyMethod) {
        
        if let applStep = data.applStep, applStep != "null" {
            applStepLabel.designed(text: applStep, fontType: .p14Bold, textColor: .black)
        } else {
            applStepFlexView.flex.display(.none)
        }
        
        if let evaluation = data.evaluation, evaluation != "null" {
            evaluationLabel.designed(text: evaluation, fontType: .p14Bold, textColor: .black)
        } else {
            evaluationFlexView.flex.display(.none)
        }
        
        if let applUrl = data.applUrl, applUrl != "null" {
            applUrlLabel.designed(text: applUrl, fontType: .p14Bold, textColor: .black)
        } else {
            applUrlFlexView.flex.display(.none)
        }
        
        if let submitDoc = data.submitDoc, submitDoc != "null" {
            submitDocLabel.designed(text: submitDoc, fontType: .p14Bold, textColor: .black)
        } else {
            submitDocFlexView.flex.display(.none)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return flexView.frame.size
    }
}

extension MethodTableViewCell {
    
    fileprivate func layout() {
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    @discardableResult
    private func addItemLine(flex: Flex, flexView: UIView, titleLabel: UILabel, contentLabel: UILabel) -> Flex {
        
        let width = UIScreen.main.bounds.width / 4
        
        contentLabel.numberOfLines = 0
        
        return flex.addItem(flexView).define { flex in
            
            flex.addItem(titleLabel)
                .width(width)
                .markDirty()
            
            flex.addItem(contentLabel)
                .grow(1)
                .shrink(1)
                .markDirty()
        }
        .alignItems(.start)
        .direction(.row)
        .markDirty()
    }
}
