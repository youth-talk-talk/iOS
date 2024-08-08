//
//  DetailTableViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/2/24.
//

import UIKit
import PinLayout
import FlexLayout

class DetailTableViewCell: BaseTableViewCell {
    
    let plusImageView = UIImageView()
    let sectionTitleLabel = UILabel()
    
    let etcTitleLabel = UILabel()
    let etcLabel = UILabel()
    
    let hostOperatingTitleLabel = UILabel()
    let hostTitleLabel = UILabel()
    let hostLabel = UILabel()
    
    let operatingTitleLabel = UILabel()
    let operatingLabel = UILabel()
    
    let refSiteTitleLabel = UILabel()
    let refFirstTitleLabel = UILabel()
    let refFirstLabel = UILabel()
    
    let refSecondTitleLabel = UILabel()
    let refSecondLabel = UILabel()
    
    let applyButton = UIButton()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            // 정보 타이틀
            flex.addItem().define { flex in
                
                flex.addItem(plusImageView)
                    .size(24)
                    .marginLeft(0)
                
                flex.addItem(sectionTitleLabel)
                    .marginLeft(4)
            }
            .direction(.row)
            .marginTop(24)
            
            // 하위 항목들
            // 1) 기타 정보
            flex.addItem(etcTitleLabel)
                .marginTop(12)
            
            flex.addItem(etcLabel)
            
            // 2) 주관기관 및 운영기관
            flex.addItem(hostOperatingTitleLabel)
                .marginTop(12)
            
            flex.addItem().define { flex in
                
                flex.addItem(hostTitleLabel)
                flex.addItem(hostLabel)
            }
            .alignItems(.start)
            .marginTop(4)
            .direction(.row)
            
            flex.addItem().define { flex in
                
                flex.addItem(operatingTitleLabel)
                flex.addItem(operatingLabel)
            }
            .alignItems(.start)
            .direction(.row)
            
            // 3) 참고사이트
            flex.addItem(refSiteTitleLabel)
                .marginTop(12)
            
            flex.addItem(refFirstTitleLabel)
                .marginTop(4)
            flex.addItem(refFirstLabel)
                .marginLeft(20)
            
            flex.addItem(refSecondTitleLabel)
            flex.addItem(refSecondLabel)
                .marginLeft(20)
            
            // 4) 지원버튼
            flex.addItem(applyButton)
                .marginTop(30)
                .defaultButton()
                .markDirty()
        }
    }
    
    override func configureView() {
        
        plusImageView.image = UIImage.plus
        
        sectionTitleLabel.designed(text: "더 자세한 정보를 알려주세요", fontType: .p18Bold, textColor: .black)
        
        etcTitleLabel.designed(text: "기타정보", fontType: .p16SemiBold, textColor: .gray50)
        hostOperatingTitleLabel.designed(text: "주관기관 및 운영기관", fontType: .p16SemiBold, textColor: .gray50)
        refSiteTitleLabel.designed(text: "참고 사이트", fontType: .p16SemiBold, textColor: .gray50)
        hostTitleLabel.designed(text: "-주관 기관: ", fontType: .p14Regular, textColor: .black)
        operatingTitleLabel.designed(text: "-운영 기관: ", fontType: .p14Regular, textColor: .black)
        refFirstTitleLabel.designed(text: "-사업관련 참고 사이트 1", fontType: .p14Regular, textColor: .black)
        refSecondTitleLabel.designed(text: "-사업관련 참고 사이트 2", fontType: .p14Regular, textColor: .black)
        
        applyButton.designed(title: "지원하기", titleColor: .black, fontType: .p16Regular16, withAction: true)
    }
    
    func configure(_ data: DetailPolicyEntity.PolicyDetail) {
        
        etcLabel.designed(text: data.etc ?? "-", fontType: .p14Regular, textColor: .black)
        hostLabel.designed(text: data.hostDep ?? "-", fontType: .p14Regular, textColor: .black)
        operatingLabel.designed(text: data.operatingOrg ?? "-", fontType: .p14Regular, textColor: .black)
        
        refFirstLabel.designed(text: data.refUrl1 ?? "-", fontType: .p14Regular, textColor: .black)
        refSecondLabel.designed(text: data.refUrl2 ?? "-", fontType: .p14Regular, textColor: .black)
        
        etcLabel.numberOfLines = 0
        hostLabel.numberOfLines = 0
        operatingLabel.numberOfLines = 0
        refFirstLabel.numberOfLines = 0
        refSecondLabel.numberOfLines = 0
        
        if !isValid(data.applUrlv) {
            applyButton.flex.display(.none)
            applyButton.designed(title: "")
            layout()
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

extension DetailTableViewCell {
    
    fileprivate func layout() {
        
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    private func isValid(_ url: String?) -> Bool {
        
        guard let url else { return false }
        
        if url == "" { return false }
        
        if url == "null" { return false }
        
        return true
    }
}
