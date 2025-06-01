//
//  PopularPostCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class PopularPostCell: UICollectionViewCell {
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(6)
    }
    
    private let policyLabel = UILabel().then {
        $0.designed(text: "정책 타이틀", font: .p12Regular)
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(font: .p16Regular16)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 2
        $0.setTextWithLineHeight(text: "게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀, 게시글 타이틀", lineHeight: 23)
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(text: "게시글 내용 들어갈 부분, 게시글 내용 들어갈 부분", font: .p12Regular, textColor: .gray90)
        $0.lineBreakMode = .byTruncatingTail
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
    
    private let actionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setShadow()
        
        layer.cornerRadius = moderate(12)
        addSubview(stackView)
        
        stackView.addArrangedSubviews(
            policyLabel,
            titleLabel,
            contentLabel,
            actionView
        )
        
        actionView.addSubviews(commentImageView,
                               commentCountLabel,
                               scrapImageView,
                               scrapCountLabel,
                               dateLabel)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderate(20))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        actionView.snp.makeConstraints {
            $0.height.equalTo(moderate(16))
        }
        
        commentImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderate(16))
            $0.leading.equalTo(contentLabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderate(2))
        }
        
        scrapImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderate(16))
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(moderate(10))
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(scrapImageView.snp.trailing).offset(moderate(2))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ post: RPDTO) {
        titleLabel.text = post.title
        policyLabel.text = post.policyTitle
        policyLabel.isHidden = post.policyId == nil
        contentLabel.text = post.contentPreview
        commentCountLabel.text = String(post.comments)
        scrapCountLabel.text = String(post.scraps ?? 0)
    }
}
