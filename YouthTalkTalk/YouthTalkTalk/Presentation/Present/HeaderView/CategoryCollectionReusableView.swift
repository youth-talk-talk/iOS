//
//  CategoryCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout
import PinLayout

final class CategoryCollectionReusableView: BaseCollectionReusableView {
    
    let gradientView = UIView()
    
    let searchBar = UISearchBar()
    let transparentView = UIView()
    
    let jobCategoryButton = UIButton()
    let educationCategoryButton = UIButton()
    let cultureCategoryButton = UIButton()
    let collaborateCategoryButton = UIButton()
    
    override func configureLayout() {
        
        flexView.addSubview(gradientView)
        flexView.addSubview(searchBar)
        flexView.addSubview(transparentView)
        
        flexView.flex.define { flex in
            
            flex.addItem(gradientView)
                .position(.absolute)
                .top(0)
                .horizontally(0)
                .backgroundColor(.customGreen)
            
            flex.addItem(searchBar)
                .defaultCornerRadius()
                .defaultHeight()
                .marginTop(16)
                .border(1, .gray20)
                .width(90%)
            
            flex.addItem(transparentView)
                .position(.absolute)
                .top(searchBar.frame.minY)
                .height(searchBar.frame.height)
                .width(searchBar.frame.width)
                .backgroundColor(.brown)
            
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
        
        searchBar.layer.masksToBounds = true
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white.withAlphaComponent(0.95)
        searchBar.searchTextField.leftView?.tintColor = .lime40
        searchBar.isUserInteractionEnabled = false
        
        transparentView.isUserInteractionEnabled = true
        
        jobCategoryButton.designedCategoryLayout(title: "일자리", image: .job)
        educationCategoryButton.designedCategoryLayout(title: "교육", image: .education)
        cultureCategoryButton.designedCategoryLayout(title: "생활지원", image: .culture)
        collaborateCategoryButton.designedCategoryLayout(title: "참여", image: .collaborate)
        
        if let textfieldBackgroundView = searchBar.searchTextField.subviews.first {
            textfieldBackgroundView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        transparentView.flex
            .position(.absolute)
            .top(searchBar.frame.minY)
            .height(searchBar.frame.height)
            .width(searchBar.frame.width)
            .backgroundColor(.clear)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let height = searchBar.frame.maxY - (Flex.defaultHeight / 2)
        
        gradientView.flex.height(height)
        
        flexView.pin.all(self.pin.safeArea)
        flexView.flex.layout(mode: .adjustHeight)
        
        return flexView.frame.size
    }
}
