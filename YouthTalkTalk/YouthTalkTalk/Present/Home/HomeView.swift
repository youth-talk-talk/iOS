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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeLayout.layout())
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(collectionView).grow(1)
        }
    }
    
    override func configureView() {
        
        flexView.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func layoutSubviews() {
        
        flexView.pin.all()
        flexView.flex.layout()
    }
}
