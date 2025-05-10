//
//  CategoryCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    private let categoryImageView = UIImageView()
    
    private let categoryLabel = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray90)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([categoryImageView, categoryLabel])
        
        categoryImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerX.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(categoryImageView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(categoryImage: UIImage, categoryName: String, isSelected: Bool = false) {
        categoryImageView.image = categoryImage
        categoryLabel.text = categoryName
        setSelection(isSelected)
    }
    
    func setSelection(_ isSelected: Bool) {
        categoryLabel.designed(font: isSelected ? .p14Bold : .p14Regular, textColor: isSelected ? .green : .gray90)
    }
}
