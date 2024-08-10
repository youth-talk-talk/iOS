//
//  SearchHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

class SearchHeaderView: BaseCollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    let categoryView = UIView()
    
    let jobCheckBoxButton = UIButton()
    let jobLiteralLabel = UILabel()
    
    let educationCheckBoxButton = UIButton()
    let educationLiteralLabel = UILabel()
    
    let lifeCheckBoxButton = UIButton()
    let lifeLiteralLabel = UILabel()
    
    let participationCheckBoxButton = UIButton()
    let participationLiteralLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        jobCheckBoxButton.configuration?.image = nil
        educationCheckBoxButton.configuration?.image = nil
        lifeCheckBoxButton.configuration?.image = nil
        participationCheckBoxButton.configuration?.image = nil
        
        jobLiteralLabel.designed(text: "", fontType: .p14Bold, textColor: .gray60)
        educationLiteralLabel.designed(text: "", fontType: .p14Bold, textColor: .gray60)
        lifeLiteralLabel.designed(text: "", fontType: .p14Bold, textColor: .gray60)
        participationLiteralLabel.designed(text: "", fontType: .p14Bold, textColor: .gray60)
    }
    
    override func configureLayout() {
        
        flexView.addSubview(categoryView)
        
        [jobLiteralLabel, jobCheckBoxButton, educationLiteralLabel, educationCheckBoxButton, lifeLiteralLabel, lifeCheckBoxButton, participationLiteralLabel, participationCheckBoxButton].forEach { flexView.addSubview($0) }
        
        flexView.flex.define { flex in
            
            // MARK: 서치 버튼
            flex.addItem(searchButton)
                .defaultButton()
                .marginTop(24)
                .marginBottom(24)
                .border(1, .gray20)
                .width(90%)
                .alignSelf(.center)
            
            // MARK: 카테고리
            flex.addItem(categoryView).define { flex in
                
                // 일자리
                flex.addItem().define { flex in
                    flex.addItem(jobCheckBoxButton)
                        .width(15)
                        .height(15)
                        .markDirty()
                    
                    flex.addItem(jobLiteralLabel)
                        .marginLeft(7)
                        .markDirty()
                }
                .alignItems(.center)
                .direction(.row)
                
                // 교육
                flex.addItem().define { flex in
                    flex.addItem(educationCheckBoxButton)
                        .width(15)
                        .height(15)
                        .markDirty()
                    
                    flex.addItem(educationLiteralLabel)
                        .marginLeft(7)
                        .markDirty()
                }
                .alignItems(.center)
                .direction(.row)
                
                // 생활지원
                flex.addItem().define { flex in
                    flex.addItem(lifeCheckBoxButton)
                        .width(15)
                        .height(15)
                        .markDirty()
                    
                    flex.addItem(lifeLiteralLabel)
                        .marginLeft(7)
                        .markDirty()
                }
                .alignItems(.center)
                .direction(.row)
                
                // 참여
                flex.addItem().define { flex in
                    flex.addItem(participationCheckBoxButton)
                        .width(15)
                        .height(15)
                        .markDirty()
                    
                    flex.addItem(participationLiteralLabel)
                        .marginLeft(7)
                        .markDirty()
                }
                .alignItems(.center)
                .direction(.row)
                .markDirty()
            }
            .direction(.row)
            .marginLeft(5%)
            .marginBottom(24)
            .marginTop(-12)
            .width(90%)
            .justifyContent(.spaceBetween)
        }
    }
    
    override func configureView() {
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage.magnifyingglass.withTintColor(.lime40, renderingMode: .alwaysOriginal)
        buttonConfiguration.background.backgroundColor = .white.withAlphaComponent(0.95)
        buttonConfiguration.titleAlignment = .leading
        buttonConfiguration.imagePlacement = .leading
        buttonConfiguration.title = " "
        
        searchButton.configuration = buttonConfiguration
    }
    
    func configureWithCategory() {
        
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
        
        jobLiteralLabel.designed(text: "일자리", fontType: .p14Bold, textColor: .gray60)
        educationLiteralLabel.designed(text: "교육", fontType: .p14Bold, textColor: .gray60)
        lifeLiteralLabel.designed(text: "생활지원", fontType: .p14Bold, textColor: .gray60)
        participationLiteralLabel.designed(text: "참여", fontType: .p14Bold, textColor: .gray60)
    }
    
    func configureWithOutCategory() {
        jobCheckBoxButton.flex.display(.none)
        educationCheckBoxButton.flex.display(.none)
        lifeCheckBoxButton.flex.display(.none)
        participationCheckBoxButton.flex.display(.none)
        
        jobLiteralLabel.flex.display(.none)
        educationLiteralLabel.flex.display(.none)
        lifeLiteralLabel.flex.display(.none)
        participationLiteralLabel.flex.display(.none)
        
        self.categoryView.flex.display(.none)
        
        self.flexView.flex.layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchButton.configuration?.imagePadding = searchButton.bounds.size.width - (UIScreen.main.bounds.width * 0.15)
    }
}
