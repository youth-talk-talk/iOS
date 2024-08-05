//
//  TargetTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import PinLayout
import FlexLayout

enum PolicyTargetType: Int, CaseIterable {
    
    case age
    case addrIncome
    case education
    case major
    case employment
    case specialization
    case appLimit
    case addition
    
    var text: String {
        switch self {
        case .age:
            "연령"
        case .addrIncome:
            "거주지 및 소득"
        case .education:
            "학력"
        case .major:
            "전공"
        case .employment:
            "취업상태"
        case .specialization:
            "특화분야"
        case .appLimit:
            "참여제한"
        case .addition:
            "추가사항"
        }
    }
}

class TargetTableViewCell: BaseTableViewCell {
    
    let personImageView = UIImageView()
    let sectionTitleLabel = UILabel()
    
    let ageFlexView = UIView()
    let ageTitleLabel = UILabel()
    let ageLabel = UILabel()
    
    let addrIncomeFlexView = UIView()
    let addrIncomeTitleLabel = UILabel()
    let addrIncomeLabel = UILabel()
    
    let educationFlexView = UIView()
    let educationTitleLabel = UILabel()
    let educationLabel = UILabel()
    
    let majorFlexView = UIView()
    let majorTitleLabel = UILabel()
    let majorLabel = UILabel()
    
    let employmentFlexView = UIView()
    let employmentTitleLabel = UILabel()
    let employmentLabel = UILabel()
    
    let specializationFlexView = UIView()
    let specializationTitleLabel = UILabel()
    let specializationLabel = UILabel()
    
    let applLimitFlexView = UIView()
    let applLimitTitleLabel = UILabel()
    let applLimitLabel = UILabel()
    
    let additionFlexView = UIView()
    let additionTitleLabel = UILabel()
    let additionLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
                
                flex.addItem(personImageView)
                    .size(24)
                    .marginLeft(0)
                
                flex.addItem(sectionTitleLabel)
                    .marginLeft(4)
            }
            .direction(.row)
            .marginTop(24)
            
            // 연령
            addItemLine(flex: flex, flexView: ageFlexView, titleLabel: ageTitleLabel, contentLabel: ageLabel)
                .marginTop(12)
            
            // 거주지 및 소득
            addItemLine(flex: flex, flexView: addrIncomeFlexView, titleLabel: addrIncomeTitleLabel, contentLabel: addrIncomeLabel)
                .marginTop(4)
            
            // 학력
            addItemLine(flex: flex, flexView: educationFlexView, titleLabel: educationTitleLabel, contentLabel: educationLabel)
                .marginTop(4)
            
            // 전공
            addItemLine(flex: flex, flexView: majorFlexView, titleLabel: majorTitleLabel, contentLabel: majorLabel)
                .marginTop(4)
            
            // 취업 상태
            addItemLine(flex: flex, flexView: employmentFlexView, titleLabel: employmentTitleLabel, contentLabel: employmentLabel)
            
            // 특화 분야
            addItemLine(flex: flex, flexView: specializationFlexView, titleLabel: specializationTitleLabel, contentLabel: specializationLabel)
                .marginTop(4)
            
            // 참여 제한
            addItemLine(flex: flex, flexView: applLimitFlexView, titleLabel: applLimitTitleLabel, contentLabel: applLimitLabel)
                .marginTop(4)
            
            // 추가 사항
            addItemLine(flex: flex, flexView: additionFlexView, titleLabel: additionTitleLabel, contentLabel: additionLabel)
                .marginTop(4)
        }
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
    
    override func configureView() {
        
        personImageView.image = UIImage.person
        
        sectionTitleLabel.designed(text: "누구를 위한 정책인가요?", fontType: .p18Bold, textColor: .black)
        
        let titleLabels = [ageTitleLabel, addrIncomeTitleLabel, educationTitleLabel, majorTitleLabel, employmentTitleLabel, specializationTitleLabel, applLimitTitleLabel, additionTitleLabel]
        
        for i in 0 ..< titleLabels.count {
            
            guard let type = PolicyTargetType(rawValue: i) else { return }
            
            titleLabels[i].designed(text: type.text, fontType: .p16SemiBold, textColor: .gray50)
        }
    }
    
    func configure(_ data: DetailPolicyEntity.PolicyTarget) {
        
        ageLabel.designed(text: data.age, fontType: .p14Bold, textColor: .black)
        
        if let addrIncome = data.addrIncome, addrIncome != "null" {
            addrIncomeLabel.designed(text: addrIncome, fontType: .p14Bold, textColor: .black)
        } else {
            addrIncomeFlexView.flex.display(.none)
        }
        
        if let education = data.education, education != "null" {
            educationLabel.designed(text: education, fontType: .p14Bold, textColor: .black)
        } else {
            educationFlexView.flex.display(.none)
        }
        
        if let major = data.major, major != "null" {
            majorLabel.designed(text: major, fontType: .p14Bold, textColor: .black)
        } else {
            majorFlexView.flex.display(.none)
        }
        
        if let employment = data.employment, employment != "null"  {
            employmentLabel.designed(text: employment, fontType: .p14Bold, textColor: .black)
        } else {
            employmentFlexView.flex.display(.none)
        }
        
        if let specialization = data.specialization, specialization != "null" {
            specializationLabel.designed(text: specialization, fontType: .p14Bold, textColor: .black)
        } else {
            specializationFlexView.flex.display(.none)
        }
        
        if let applLimit = data.applLimit, applLimit != "null" {
            applLimitLabel.designed(text: applLimit, fontType: .p14Bold, textColor: .black)
        } else {
            applLimitFlexView.flex.display(.none)
        }
        
        if let addition = data.addition, addition != "null" {
            additionLabel.designed(text: addition, fontType: .p14Bold, textColor: .black)
        } else {
            additionFlexView.flex.display(.none)
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
