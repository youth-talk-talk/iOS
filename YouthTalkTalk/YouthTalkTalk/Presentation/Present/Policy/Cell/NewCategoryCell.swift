//
//  NewCategoryCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class NewCategoryCell: UICollectionViewCell {
    let label = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray40.cgColor
        layer.cornerRadius = moderate(16)
        
        addSubviews(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(13))
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
