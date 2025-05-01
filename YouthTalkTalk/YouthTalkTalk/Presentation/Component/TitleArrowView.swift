//
//  TitleArrowView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class TitleArrowView: UIView {
    private let label = UILabel().then {
        $0.designed(font: .p16SemiBold, textColor: .gray100)
    }
    
    private let arrowImageView = UIImageView(image: .chevronRight)
    
    init(text: String) {
        super.init(frame: .zero)

        label.text = text
        
        addSubviews(label, arrowImageView)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.size.equalTo(moderate(24))
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
