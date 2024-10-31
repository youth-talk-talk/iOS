//
//  UIButton++.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit

extension UIButton {
    
    // 이미지 버튼
    func designedByImage(_ image: UIImage) {
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 0 // 이미지와 텍스트 사이의 패딩을 0으로 설정
        buttonConfiguration.imagePlacement = .all
        
        self.configuration = buttonConfiguration
        
        updateHandler(bgColor: .clear)
    }
    
    // 이미지 버튼
    func designWithImage(title: String, image: UIImage, bgColor: UIColor, titleColor: UIColor, fontType: FontType) {
        
        var titleAttrribute = AttributedString.init(title)
        titleAttrribute.font = FontManager.font(fontType)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 2 // 이미지와 텍스트 사이의 패딩을 0으로 설정
        buttonConfiguration.imagePlacement = .leading
        
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseBackgroundColor = bgColor
        buttonConfiguration.baseForegroundColor = titleColor
        buttonConfiguration.background.cornerRadius = 8
        
        self.configuration = buttonConfiguration
    }
    
    // 기본 버튼 디자인
    func designed(title: String, titleColor: UIColor = .black, bgColor: UIColor = .lime40, fontType: FontType = .p16Regular16, withAction: Bool = true) {
        
        var titleAttrribute = AttributedString.init(title)
        titleAttrribute.font = FontManager.font(fontType)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseBackgroundColor = bgColor
        buttonConfiguration.baseForegroundColor = titleColor
        buttonConfiguration.background.cornerRadius = 8
        
        self.configuration = buttonConfiguration
        
        if withAction { updateHandler(bgColor: bgColor) }
    }
    
    func designedCategoryLayout(title: String, image: UIImage) {
        
        var titleAttrribute = AttributedString.init(title)
        titleAttrribute.font = FontManager.font(.p16SemiBold)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.baseForegroundColor = .gray60
        
        buttonConfiguration.image = image
        buttonConfiguration.imagePlacement = .top
        buttonConfiguration.imagePadding = 5
        
        self.configuration = buttonConfiguration
    }
    
    // 버튼 업데이트 핸들러
    private func updateHandler(bgColor: UIColor) {
        
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            
            switch btn.state {
            case .disabled:
                btn.configuration?.background.backgroundColor = .systemGray
            case .highlighted:
                btn.animate()
            default:
                btn.configuration?.background.backgroundColor = bgColor
            }
        }
        
        self.configurationUpdateHandler = updateHandler
    }
    
    // 버튼 애니메이션
    private func animate() {
        
        UIButton.animate(withDuration: 0.03, delay: 0, options: .autoreverse , animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
