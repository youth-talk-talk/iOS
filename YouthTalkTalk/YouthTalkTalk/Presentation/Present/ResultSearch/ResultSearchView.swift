//
//  ResultSearchView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit
import FlexLayout
import PinLayout

final class ResultSearchView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultSearchLayout.layout())

    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(collectionView)
                .grow(1)
        }
    }
    
    override func configureView() {
        
        
    }

}
