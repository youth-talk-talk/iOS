//
//  RecentHeaderReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/21/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class RecentHeaderReusableView: BaseCollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    
    let jobCheckBoxButton = UIButton()
    let jobLiteralLabel = UILabel()
    
    let educationCheckBoxButton = UIButton()
    let educationLiteralLabel = UILabel()
    
    let lifeCheckBoxButton = UIButton()
    let lifeLiteralLabel = UILabel()
    
    let participationCheckBoxButton = UIButton()
    let participationLiteralLabel = UILabel()
    
    override func prepareForReuse() {
        
        disposeBag = DisposeBag()
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem().define { flex in
                
                flex.addItem(titleLabel)
                    .grow(1)
                
                flex.define { flex in
                    flex.addItem(jobCheckBoxButton)
                        .width(15)
                        .height(15)
                    
                    flex.addItem(jobLiteralLabel)
                        .marginLeft(3)
                    
                    // ===
                    flex.addItem(educationCheckBoxButton)
                        .width(15)
                        .height(15)
                        .marginLeft(12)
                    
                    flex.addItem(educationLiteralLabel)
                        .marginLeft(3)
                    
                    // ===
                    flex.addItem(lifeCheckBoxButton)
                        .width(15)
                        .height(15)
                        .marginLeft(12)
                    
                    flex.addItem(lifeLiteralLabel)
                        .marginLeft(3)
                    
                    // ===
                    flex.addItem(participationCheckBoxButton)
                        .width(15)
                        .height(15)
                        .marginLeft(12)
                    
                    flex.addItem(participationLiteralLabel)
                        .marginLeft(3)
                }
            }
            .direction(.row)
            .alignContent(.spaceBetween)
            .alignItems(.center)
            .marginTop(24)
            .marginBottom(12)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "최근 업데이트", fontType: .g14Bold, textColor: .gray60)
        
        let checkmarkImage = UIImage.emptyCheckbox.withTintColor(.gray30, renderingMode: .alwaysOriginal)
        
        jobCheckBoxButton.designedByImage(checkmarkImage)
        educationCheckBoxButton.designedByImage(checkmarkImage)
        lifeCheckBoxButton.designedByImage(checkmarkImage)
        participationCheckBoxButton.designedByImage(checkmarkImage)
        
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            
            switch btn.state {
                
            case .normal:
                btn.configuration?.image = checkmarkImage
                
            case .selected:
                btn.configuration?.image = UIImage.checkbox
                
            default:
                return
            }
        }
        
        jobCheckBoxButton.isSelected = true
        educationCheckBoxButton.isSelected = true
        lifeCheckBoxButton.isSelected = true
        participationCheckBoxButton.isSelected = true
        
        jobCheckBoxButton.configurationUpdateHandler = updateHandler
        educationCheckBoxButton.configurationUpdateHandler = updateHandler
        lifeCheckBoxButton.configurationUpdateHandler = updateHandler
        participationCheckBoxButton.configurationUpdateHandler = updateHandler
        
        jobLiteralLabel.designed(text: "일자리", fontType: .p12Regular, textColor: .gray60)
        educationLiteralLabel.designed(text: "교육", fontType: .p12Regular, textColor: .gray60)
        lifeLiteralLabel.designed(text: "생활지원", fontType: .p12Regular, textColor: .gray60)
        participationLiteralLabel.designed(text: "참여", fontType: .p12Regular, textColor: .gray60)
    }
    
    deinit {
        print("RecentHeaderReusableView Deinit")
    }
}
