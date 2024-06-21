//
//  HomeView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

class HomeView: BaseView {
    
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
        
        let inset = self.safeAreaInsets.top
        
        colorView.flex.height(inset)
        collectionView.flex.top(inset)
        
        flexView.pin.all()
        flexView.flex.layout()
    }
}
