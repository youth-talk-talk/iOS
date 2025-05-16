//
//  PolicyCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit
import Kingfisher

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        policyView.resetCategory()
    }
    
    func setStyle(_ style: policyCellStyle) {
        policyView.setStyle(style)
    }
    
    func setData(_ policyData: PolicyDTO) {
        policyView.setData(policyData)
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
        $0.spacing = 8    }
    
    let scrapImageView = UIImageView(image: .bookmarkLine)
    
    let scrapCountLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray90)
    }
    
    let hostImageTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.alignment = .center
    }
    
    let hostImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderate(28)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.designed(font: .p16Regular16)
        $0.numberOfLines = 2
    }
                    
    let totalScrapLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray80)
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
        }
        
        hostImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(56))
        }
    }
    
    func resetCategory() {
        hostImageView.image = nil
        
        tagStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            tagStackView.removeArrangedSubview(view)
        }
    }
    
    func setData(_ data: PolicyDTO) {
        titleLabel.text = data.title
        scrapCountLabel.text = String(data.scrapCount)
        totalScrapLabel.text = "총 \(data.scrapCount)회 스크랩 됐어요!"

        if data.departmentImgUrl == "default" || data.departmentImgUrl == nil {
            hostImageView.image = .govermentNull
        } else {
            hostImageView.kf.setImage(with: URL(string: data.departmentImgUrl!))
        }
        
        if data.deadlineStatus != "" {
            let tagView = makeTagView(text: data.deadlineStatus, isRed: true)
            tagStackView.addArrangedSubview(tagView)
        }
        
        if data.category != "" {
            let tagView = makeTagView(text: PolicyCategory(rawValue: data.category)?.name ?? data.category)
            tagStackView.addArrangedSubview(tagView)
        }
        
        // 현재 내 지역 태그에 추가
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
    
    private func makeTagView(text: String, isRed: Bool = false) -> UIView {
        let view = UIView().then {
            $0.backgroundColor = isRed ? .redLight : .gray30
            $0.layer.cornerRadius = moderate(4)
        }
        
        let label = UILabel().then {
            $0.designed(text: text, font: .p12Regular, textColor: isRed ? .accentRed : .gray80)
        }
        
        view.addSubview(label)
        
        view.snp.makeConstraints {
            $0.height.equalTo(moderate(21))
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderate(6))
        }
        
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
