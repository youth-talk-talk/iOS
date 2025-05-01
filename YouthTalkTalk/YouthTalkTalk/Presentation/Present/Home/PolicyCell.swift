//
//  PolicyCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class PolicyCell: UICollectionViewCell {
    
    private let policyView = NewPolicyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(policyView)
        
        policyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setStyle(_ style: policyCellStyle) {
        policyView.setStyle(style)
    }
    
    func setData(categoryImage: UIImage, categoryName: String) {
    }
}

enum policyCellStyle {
    case shadow
    case border
}

final class NewPolicyView: UIView {
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(14)
        $0.alignment = .leading
    }
    
    let tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .gray40
    }
    
    let scrapImageView = UIImageView(image: .bookmarkLine)
    
    let scrapCountLabel = UILabel().then {
        $0.designed(text: "스크랩 수", font: .p12Regular, textColor: .gray90)
    }
    
    let hostImageTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.alignment = .center
    }
    
    let hostImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 28
    }
    
    let titleLabel = UILabel().then {
        $0.designed(text: "정책 타이틀입니다.", font: .p16Regular16)
    }
                    
    let totalScrapLabel = UILabel().then {
        $0.designed(text: "총 12회 스크랩 됐어요!", font: .p12Regular, textColor: .gray80)
        $0.changeFont(forText: "232", withNewFont: FontManager.font(.p12Regular))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        
        setShadow()
        
        addSubview(contentStackView)
        addSubview(scrapCountLabel)
        addSubview(scrapImageView)
        
        contentStackView.addArrangedSubviews(tagStackView,
                                             hostImageTitleStackView,
                                             totalScrapLabel)
        
        hostImageTitleStackView.addArrangedSubviews(hostImageView, titleLabel)
        
        
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderate(16))
            $0.leading.trailing.equalToSuperview().inset(moderate(14))
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderate(16))
            $0.trailing.equalToSuperview().inset(moderate(14))
        }
        
        scrapImageView.snp.makeConstraints {
            $0.trailing.equalTo(scrapCountLabel.snp.leading)
            $0.size.equalTo(moderate(20))
            $0.centerY.equalTo(scrapCountLabel)
        }
        
        tagStackView.snp.makeConstraints {
            $0.height.equalTo(moderate(21))
            $0.width.equalTo(moderate(100))
        }
        
        hostImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(56))
        }
    }
    
    func setStyle(_ style: policyCellStyle) {
        if style == .shadow {
            setShadow()
        } else {
            backgroundColor = .gray10
            layer.shadowColor = UIColor.clear.cgColor
            layer.borderColor = UIColor.gray40.cgColor
            layer.borderWidth = 1
            
            totalScrapLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
