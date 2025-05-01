//
//  NewPostCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class NewPostCell: UICollectionViewCell {
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(16)
        $0.alignment = .leading
    }
    
    private let categoryLabel = PaddedLabel(topBottom: 2, leftRight: 6) .then {
        $0.designed(text: "카테고리", font: .p12Regular, textColor: .gray80)
        $0.layer.cornerRadius = moderate(4)
        $0.backgroundColor = .gray30
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀", font: .p16Regular16)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(text: "게시글 내용 들어갈 부분, 게시글 내용 들어갈 부분", font: .p12Regular, textColor: .gray90)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    private let policyView = UIView().then {
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderate(4)
    }
    
    private let policyLabel = UILabel().then {
        $0.designed(text: "정책 타이틀", font: .p14Regular, textColor: .gray90)
        $0.numberOfLines = 1
    }
    
    private let bottomActionView = UIView()
    private let commentImageView = UIImageView(image: .comments.withTintColor(.gray80))
    private let commentCountLabel = UILabel().then {
        $0.designed(text: "코멘트 개수", font: .p12Regular, textColor: .gray80)
    }
    
    private let scrapImageView = UIImageView(image: .bookmarkLine.withTintColor(.gray80))
    private let scrapCountLabel = UILabel().then {
        $0.designed(text: "스크랩 개수", font: .p12Regular, textColor: .gray80)
    }
    
    private let dateLabel = UILabel().then {
        $0.designed(text: "게시글 날짜", font: .p12Regular, textColor: .gray80)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(contentStackView)
        addSubviews(dividerView)
        
        contentStackView.addArrangedSubviews(categoryLabel,
                                             titleLabel,
                                             contentLabel,
                                             policyView,
                                             bottomActionView)
        
        contentStackView.setCustomSpacing(moderate(10), after: categoryLabel)
        contentStackView.setCustomSpacing(moderate(4), after: titleLabel)
        
        policyView.addSubview(policyLabel)
        bottomActionView.addSubviews(commentImageView,
                                     commentCountLabel,
                                     scrapImageView,
                                     scrapCountLabel,
                                     dateLabel)
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dividerView.snp.top).offset(-moderate(20))
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(moderate(1))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        commentImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(moderate(16))
            $0.leading.equalTo(contentLabel)
        }
        
        policyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(moderate(42))
        }
        
        policyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderate(2))
        }
        
        scrapImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.size.equalTo(moderate(16))
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(moderate(10))
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(scrapImageView.snp.trailing).offset(moderate(2))
        }
        
        bottomActionView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
