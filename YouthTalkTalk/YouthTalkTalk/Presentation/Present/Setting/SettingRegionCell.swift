//
//  SettingRegionCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 2/4/25.
//

import UIKit

final class SettingRegionCell: UICollectionViewCell {
    let title = UILabel().then {
        $0.font = FontManager.font(.p16Regular16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray40.cgColor
        
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
