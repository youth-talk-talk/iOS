//
//  CategoryButtonHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class CategoryButtonHeaderView: BaseCollectionReusableView {
    
    final var disposeBag = DisposeBag()
    
    let gradientView = UIView()
    
    let searchButton = UIButton()
    
    let jobCategoryButton = UIButton()
    let educationCategoryButton = UIButton()
    let cultureCategoryButton = UIButton()
    let collaborateCategoryButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func configureLayout() {
        
        flexView.addSubview(gradientView)
        flexView.addSubview(searchButton)
        
        flexView.flex.define { flex in
            
            flex.addItem(gradientView)
                .position(.absolute)
                .top(0)
                .horizontally(0)
                .width(100%)
                .backgroundColor(.customGreen)
            
            flex.addItem(searchButton)
                .defaultButton()
                .marginTop(16)
                .border(1, .gray20)
                .width(90%)
            
            // 카테고리
            flex.addItem().define { flex in
                
                flex.addItem(jobCategoryButton)
                    .width(50)
                    .height(70)
                    .grow(1)
                
                flex.addItem(educationCategoryButton)
                    .width(50)
                    .height(70)
                    .grow(1)
                
                flex.addItem(cultureCategoryButton)
                    .width(50)
                    .height(70)
                    .grow(1)
                
                flex.addItem(collaborateCategoryButton)
                    .width(50)
                    .height(70)
                    .grow(1)
            }
            .marginTop(12)
            .direction(.row)
            .width(90%)
            .marginBottom(12)
            
        }
        .alignItems(.center)
    }
    
    override func configureView() {
        
        flexView.backgroundColor = .clear
        
        gradientView.layer.cornerRadius = 20
        gradientView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        gradientView.layer.masksToBounds = true
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage.magnifyingglass.withTintColor(.lime40, renderingMode: .alwaysOriginal)
        buttonConfiguration.background.backgroundColor = .white.withAlphaComponent(0.95)
        buttonConfiguration.titleAlignment = .leading
        buttonConfiguration.imagePlacement = .leading
        buttonConfiguration.title = " "
        
        searchButton.configuration = buttonConfiguration
        
        jobCategoryButton.designedCategoryLayout(title: "일자리", image: .job)
        educationCategoryButton.designedCategoryLayout(title: "교육", image: .education)
        cultureCategoryButton.designedCategoryLayout(title: "생활지원", image: .culture)
        collaborateCategoryButton.designedCategoryLayout(title: "참여", image: .collaborate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        searchButton.configuration?.imagePadding = searchButton.bounds.size.width - (UIScreen.main.bounds.width * 0.15)
        
        let height = searchButton.frame.maxY - (Flex.defaultHeight / 2)
        
        gradientView.flex.height(height)
        
        flexView.pin.all(self.pin.safeArea)
        flexView.flex.layout(mode: .adjustHeight)
        
        return flexView.frame.size
    }
}
