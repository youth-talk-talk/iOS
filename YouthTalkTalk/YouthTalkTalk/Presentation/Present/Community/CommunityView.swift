//
//  CommunityView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit
import PinLayout
import FlexLayout

class CommunityView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CommunityLayout.layout())
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
        }
    }

    override func configureView() {
        
        flexView.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
    }

}
