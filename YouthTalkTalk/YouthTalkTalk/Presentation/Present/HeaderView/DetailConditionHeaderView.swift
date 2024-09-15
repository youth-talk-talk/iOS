//
//  DetailConditionHeaderView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout

class DetailConditionHeaderView: BaseCollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let conditionImageView = UIImageView()
    
    var tapGesture = UITapGestureRecognizer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        tapGesture = UITapGestureRecognizer()
        
        containerView.gestureRecognizers?.removeAll()
        containerView.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        
        flexView.addSubview(containerView)
        flexView.addSubview(titleLabel)
        flexView.addSubview(conditionImageView)
        
        flexView.flex.define { flex in
            
            flex.addItem(containerView).define { flex in
                
                flex.addItem(titleLabel)
                    .height(100%)
                    .alignSelf(.center)
                    .marginLeft(13)
                    .grow(1)
                
                flex.addItem(conditionImageView)
                    .marginRight(13)
                    .alignSelf(.center)
            }
            .direction(.row)
            .width(90%)
            .height(50)
            .marginVertical(12)
            .alignSelf(.center)
            .border(1, .gray30)
            .defaultCornerRadius()
            .markDirty()
        }
    }
    
    
    override func configureView() {
        
        titleLabel.designed(text: "상세조건", fontType: .p14Regular, textColor: .gray40)
        conditionImageView.image = .detailCondition
        
        containerView.isUserInteractionEnabled = true
    }
    
    func hidden() {
        flexView.isHidden = true
        flexView.flex.height(10)
    }
}
