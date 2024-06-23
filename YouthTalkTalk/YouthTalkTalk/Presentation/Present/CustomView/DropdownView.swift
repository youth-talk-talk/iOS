//
//  DropDownView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/17/24.
//

import UIKit
import FlexLayout
import PinLayout

final class DropDownView: BaseView {

    let regionDropdownLabel = UILabel()
    let regionDropdownImage = UIImageView()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(regionDropdownLabel)
                .marginLeft(20)
                .grow(1)
            
            flex.addItem(regionDropdownImage)
                .marginRight(20)
                .alignSelf(.center)
                
        }
        .defaultButton()
        .direction(.row)
        .border(1, .gray30)
    }
    
    override func configureView() {
        
        // Region Dropdown Label
        regionDropdownLabel.designed(text: "전체지역", fontType: .p16Regualr, textColor: .gray40)
        
        // RegionDropdownImage
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.gray40, renderingMode: .alwaysOriginal)
        regionDropdownImage.image = image?.withConfiguration(imageConfiguration)
        
        // 탭 제스처 추가
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        
        flexView.pin.all()
        flexView.flex.layout()
    }
}
