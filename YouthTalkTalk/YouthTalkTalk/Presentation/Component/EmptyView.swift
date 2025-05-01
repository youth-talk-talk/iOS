//
//  EmptyView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/28/25.
//

import UIKit

final class EmptyView: UIStackView {
    private let emptyImageView = UIImageView(image: .nullIcon)
    
    private let emptyLabel = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray80)
        $0.textAlignment = .center
    }
    
    init(text: String) {
        emptyLabel.text = text
        
        super.init(frame: .zero)
        
        isHidden = true
        axis = .vertical
        alignment = .center
        spacing = 10
        
        addArrangedSubview(emptyImageView)
        addArrangedSubview(emptyLabel)
        
        emptyImageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
