//
//  HomeView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

final class HomeView: BaseView {
    
    let colorView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeLayout.layout())
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(colorView)
                .position(.absolute)
                .top(0)
                .horizontally(0)
                .height(0) // safeArea로 변경
                .backgroundColor(.customGreen)
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
        }
    }
    
    override func configureView() {
        
        flexView.addSubview(colorView)
        flexView.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topInset = self.safeAreaInsets.top
        let bottomInset = self.safeAreaInsets.bottom
        
        colorView.flex.height(topInset)
        collectionView.flex
            .top(topInset)
            .marginBottom(topInset)
        
        flexView.pin.top()
            .horizontally()
            .bottom(self.pin.safeArea.bottom)
        flexView.flex.layout()
    }
}
