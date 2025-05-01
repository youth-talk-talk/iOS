//
//  DetailFilterCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class DetailFilterCell: UICollectionViewCell {
    
    let label = UILabel().then {
        $0.designed(font: .p14Regular, textColor: .gray80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.borderColor = UIColor.gray40.cgColor
        layer.borderWidth = 1
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func adjustCellSize(height: CGFloat, label: String) -> CGSize {
        self.label.text = label
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height:height)
        return self.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority:.fittingSizeLevel,
                                                        verticalFittingPriority:.required)
    }
}
