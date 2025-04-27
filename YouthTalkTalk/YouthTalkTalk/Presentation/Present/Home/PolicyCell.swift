//
//  PolicyCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class PolicyCell: UICollectionViewCell {
    
    private let tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .gray40
    }
    
    private let scrapImageView = UIImageView(image: .bookmarkLine)
    
    private let scrapCountLabel = UILabel().then {
        $0.designed(text: "스크랩 수", font: .p12Regular, textColor: .gray90)
    }
    
    private let hostImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 28
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "정책 타이틀입니다.", font: .p16Regular16)
    }
                    
    private let totalScrapLabel = UILabel().then {
        $0.designed(text: "총 12회 스크랩 됐어요!", font: .p12Regular, textColor: .gray80)
        $0.changeFont(forText: "232", withNewFont: FontManager.font(.p12Regular))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        setShadow()
        
        addSubviews([tagStackView,
                     scrapImageView,
                     scrapCountLabel,
                     hostImageView,
                     titleLabel,
                     totalScrapLabel])
        
        tagStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(14)
            $0.height.equalTo(21)
            $0.width.equalTo(100)
        }
        
        scrapImageView.snp.makeConstraints {
            $0.trailing.equalTo(scrapCountLabel.snp.leading)
            $0.size.equalTo(20)
            $0.centerY.equalTo(tagStackView)
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(tagStackView)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        hostImageView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tagStackView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(hostImageView)
            $0.leading.equalTo(hostImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(hostImageView)
        }
        
        totalScrapLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(tagStackView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(categoryImage: UIImage, categoryName: String) {
    }
}
