//
//  TitleHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class TitleHeaderView: BaseCollectionReusableView {
        
    let disposeBag = DisposeBag()
    let titleLabel = UILabel()
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(titleLabel)
                .marginTop(15)
                .marginBottom(12)
        }
    }
    
    override func configureView() {
        
        titleLabel.designed(text: "-", fontType: .g14Bold)
    }
    
    func setTitle(_ title: String) {
        
        titleLabel.designed(text: title, fontType: .g14Bold, textColor: .gray60)
    }
}
