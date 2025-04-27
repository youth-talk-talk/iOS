//
//  PostView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit

final class PostView: UIView {
    
    private let postTypeLabel = UILabel().then {
        $0.designed(text: "게시글 타입", font: .p12Regular, textColor: .gray80)
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "리뷰 게시글 타이틀입니다.", font: .p16Regular16)
        $0.numberOfLines = 1
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(text: "리뷰 게시글 내용입니다.", font: .p12Regular, textColor: .gray80)
        $0.numberOfLines = 1
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 12
        setShadow()
        
        addSubviews([postTypeLabel,
                     titleLabel, contentLabel,
                     commentImageView, commentCountLabel,
                     scrapImageView, scrapCountLabel,
                     dateLabel])
        
        postTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postTypeLabel.snp.bottom).offset(6)
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
