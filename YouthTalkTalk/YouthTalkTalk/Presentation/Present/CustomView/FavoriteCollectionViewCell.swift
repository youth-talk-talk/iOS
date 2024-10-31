//
//  FavoriteCollectionViewCell.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit
import FlexLayout
import PinLayout

final class FavoriteCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    override func configureView() {
        
        imageView.image = UIImage.chevronRight
    }
    
    override func configureLayout() {
        
        flexView.flex.define { row in
            
            row.addItem(titleLabel)
                .alignSelf(.center)
            
            row.addItem(imageView)
                .alignSelf(.center)
        }
        .direction(.row)
        .justifyContent(.spaceBetween)
    }
}

extension FavoriteCollectionViewCell {
    
    func configure(title: String) {
        
        titleLabel.designed(text: title, fontType: .p16SemiBold, textColor: .gray60)
    }
}
