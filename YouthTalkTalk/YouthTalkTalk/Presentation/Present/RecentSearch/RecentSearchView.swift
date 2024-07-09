//
//  RecentSearchView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit
import FlexLayout
import PinLayout

final class RecentSearchView: BaseView {
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: RecentSearchLayout.layout()
    )
    
    override func configureLayout() {
        
        flexView.addSubview(collectionView)
        
        flexView.flex.define { flex in
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
        }
    }

    override func configureView() {
        
        backgroundColor = .brown
    }

}
