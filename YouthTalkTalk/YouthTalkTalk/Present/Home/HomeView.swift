//
//  HomeView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout

class HomeView: BaseView {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeLayout.layout())
    
    override func configureLayout() {
     
        flexView.flex.define { flex in
            
            flex.addItem(collectionView).grow(1)
        }
    }
    
    override func configureView() {
        
    }
}
