//
//  SearchFilterCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/29/25.
//

import UIKit

final class SearchFilterCell: UICollectionViewCell {
    
    private let titleLabel = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray80)
    }
    
    private let arrowImageView = UIImageView(image: .arrowDown)
    
    private let selectedFilterCountLabel = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray50.cgColor
        
        addSubviews([titleLabel, selectedFilterCountLabel, arrowImageView])
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(11)
        }
        
        selectedFilterCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.leading.equalTo(selectedFilterCountLabel.snp.trailing).offset(2)
            $0.size.equalTo(16)
            $0.trailing.equalToSuperview().inset(11)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
