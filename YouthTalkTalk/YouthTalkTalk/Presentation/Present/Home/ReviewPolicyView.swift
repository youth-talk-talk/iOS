//
//  ReviewPolicyView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class ReviewPolicyView: UIView {
    private let reviewPolicyTitleLabel = UILabel().then {
        $0.designed(text: "지금뜨는 정책톡톡", font: .p16SemiBold, textColor: .gray100)
    }
    
    private let reviewPolicyBaseView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 9
        $0.setShadow()
    }
    
    private let reviewPolicyImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let reviewPolicyArrowImageView = UIImageView(image: .rightArrowCircle)
    
    private let reviewPolicyLabel = UILabel().then {
        $0.designed(text: "정책 타이틀입니다.", font: .p16SemiBold)
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "리뷰 게시글 타이틀입니다.", font: .p16Regular16)
        $0.numberOfLines = 1
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(text: "리뷰 게시글 내용입니다.", font: .p12Regular, textColor: .gray80)
        $0.numberOfLines = 1
    }
    
    private let commentImageView = UIImageView(image: .comments)
    private let commentCountLabel = UILabel().then {
        $0.designed(text: "코멘트 개수", font: .p12Regular, textColor: .gray80)
    }
    
    private let scrapImageView = UIImageView(image: .bookmarkLine)
    private let scrapCountLabel = UILabel().then {
        $0.designed(text: "스크랩 개수", font: .p12Regular, textColor: .gray80)
    }
    
    private let dateLabel = UILabel().then {
        $0.designed(text: "게시글 날짜", font: .p12Regular, textColor: .gray80)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([reviewPolicyTitleLabel,
                     reviewPolicyBaseView])
        
        reviewPolicyBaseView.addSubviews([reviewPolicyImageView,
                                          reviewPolicyLabel,
                                          reviewPolicyArrowImageView,
                                          
                                          titleLabel, contentLabel,
                                          commentImageView, commentCountLabel,
                                          scrapImageView, scrapCountLabel,
                                          dateLabel])
        
        reviewPolicyTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }
        
        reviewPolicyBaseView.snp.makeConstraints {
            $0.top.equalTo(reviewPolicyTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        reviewPolicyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(50)
        }
        
        reviewPolicyLabel.snp.makeConstraints {
            $0.centerY.equalTo(reviewPolicyImageView)
            $0.leading.equalTo(reviewPolicyImageView.snp.trailing).offset(14)
            $0.trailing.equalTo(reviewPolicyArrowImageView.snp.leading).offset(-16)
        }
        
        reviewPolicyArrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(20)
            $0.centerY.equalTo(reviewPolicyImageView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(reviewPolicyImageView.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        commentImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(2)
        }
        
        scrapImageView.snp.makeConstraints {
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(commentImageView)
            $0.size.equalTo(16)
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(scrapImageView.snp.trailing).offset(2)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
