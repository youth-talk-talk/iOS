//
//  RegionCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/9/25.
//

import UIKit

final class RegionCell: UICollectionViewCell {
    
    private let regionLabel = UILabel().then {
        $0.designed(font: .p16Regular16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = FontColor.gray50.value.cgColor
        
        contentView.addSubview(regionLabel)
        
        regionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isSelected: Bool) {
        regionLabel.text = text
        
        if isSelected {
            contentView.backgroundColor = FontColor.greenLight.value
            contentView.layer.borderColor = FontColor.green.value.cgColor
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderColor = FontColor.gray50.value.cgColor
        }
    }
}
