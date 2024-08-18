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
    let createButton = UIButton()
    
    override func configureLayout() {
        
        flexView.addSubview(collectionView)
        flexView.addSubview(createButton)
        
        flexView.flex.define { flex in
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
            
            flex.addItem(createButton)
                .position(.absolute)
                .width(115)
                .height(50)
                .alignSelf(.center)
                .bottom(12)
        }
    }

    override func configureView() {
        
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        
        createButton.designed(title: "글 쓰기", fontType: .p14Bold)
        createButton.configuration?.image = .writePencil
        createButton.configuration?.imagePlacement = .leading
        createButton.configuration?.imagePadding = 8
    }

}
