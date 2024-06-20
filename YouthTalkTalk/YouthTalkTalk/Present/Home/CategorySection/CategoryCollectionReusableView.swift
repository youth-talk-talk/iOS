//
//  CategoryCollectionReusableView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/19/24.
//

import UIKit
import FlexLayout
import PinLayout

class CategoryCollectionReusableView: BaseCollectionReusableView {
    
    let gradientView = UIView()
    
    let appLabel = UILabel()
    let searchBar = UISearchBar()
    let jobImageView = UIImageView()
    
    override func configureView() {
        
        flexView.backgroundColor = .clear
        
        gradientView.layer.cornerRadius = 20
        gradientView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        gradientView.layer.masksToBounds = true
        
        appLabel.designed(text: "청년톡톡", fontType: .titleForAppBold, textColor: .black)
        
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.leftView?.tintColor = .lime40
        
        if let textfieldBackgroundView = searchBar.searchTextField.subviews.first {
            textfieldBackgroundView.isHidden = true
        }
    }
    
    func layout(safeAreaInset: CGFloat) {
        
        flexView.addSubview(gradientView)
        flexView.addSubview(appLabel)
        flexView.addSubview(searchBar)
        
        flexView.flex.define { flex in
            
            flex.addItem(gradientView)
                .position(.absolute)
                .top(0)
                .horizontally(0)
                .height(safeAreaInset)
            
            flex.addItem(appLabel)
                .marginTop(safeAreaInset)
                .width(90%)
            
            flex.addItem(searchBar)
                .defaultCornerRadius()
                .defaultHeight()
                .marginTop(16)
                .border(1, .gray20)
                .width(90%)
        }
        .alignItems(.center)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let height = searchBar.frame.maxY - 24
        
        gradientView.flex.height(height)
        flexView.flex.layout(mode: .adjustHeight)
        
        return flexView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor(red: 1/255, green: 1, blue: 194/255, alpha: 1).cgColor,
                                UIColor(red: 206/255, green: 254/255, blue: 131/255, alpha: 1).cgColor] // 시작 색상과 끝 색상 설정
        
        gradientLayer.locations = [0.0, 1.0] // 그라데이션의 시작 위치와 끝 위치 설정 (0.0 ~ 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // 시작점 설정
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0) // 종료점 설정
        // UIView의 레이어에 그라데이션 레이어 추가
        gradientView.layer.addSublayer(gradientLayer)
    }
}
