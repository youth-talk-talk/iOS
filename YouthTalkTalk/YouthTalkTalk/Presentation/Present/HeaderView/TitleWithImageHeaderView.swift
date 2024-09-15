//
//  TitleWithImageHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class TitleWithImageHeaderView: BaseCollectionReusableView {
        
    let disposeBag = DisposeBag()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(imageView)
            
            flex.addItem(titleLabel)
                .marginLeft(4)
                .alignSelf(.center)
        }
        .direction(.row)
    }
    
    override func configureView() {
        
        imageView.image = .magnifyingglass
        titleLabel.designed(text: "-", fontType: .p18Bold)
    }
    
    func setTitle(_ title: String) {
        
        titleLabel.designed(text: title, fontType: .p18Bold, textColor: .gray60)
    }
}
