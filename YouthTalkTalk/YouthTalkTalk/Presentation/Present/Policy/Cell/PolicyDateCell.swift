//
//  PolicyDateCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class PolicyDateCell: UICollectionViewCell {
    private let todayLabel = UILabel().then {
        $0.designed(text: "오늘", font: .p12Regular, textColor: .white)
    }
    
    private let dateLabel = UILabel().then {
        $0.designed(text: "31", font: .p18Semi, textColor: .white)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = moderate(20)
        
        addSubviews(todayLabel, dateLabel)
        
        todayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderate(11))
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderate(11))
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeGreen(_ isGreen: Bool) {
        backgroundColor = isGreen ? .greenNormal : .clear
        todayLabel.textColor = isGreen ? .white : .gray80
        dateLabel.textColor = isGreen ? .white : .gray70
    }
}
