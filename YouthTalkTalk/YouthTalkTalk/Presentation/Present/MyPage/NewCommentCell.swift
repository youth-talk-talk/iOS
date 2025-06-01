//
//  NewCommentCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 6/1/25.
//

import UIKit

final class NewCommentCell: UICollectionViewCell {
    private lazy var contentLabel = UILabel().then {
        $0.designed(font: .p14Regular)
        $0.numberOfLines = 0
    }
    
    private lazy var moreImageView = UIImageView(image: .more.withTintColor(.gray90))
    
    private lazy var postContainerView = UIView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = moderate(1)
        $0.layer.cornerRadius = moderate(16)
    }
    
    private lazy var postTypeLabel = PaddedLabel(topBottom: 2, leftRight: 6)
    
    private lazy var postTitleLabel = UILabel().then {
        $0.designed(font: .p14Regular)
    }
    
    private lazy var heartImageView = UIImageView(image: .like.withTintColor(.gray70))
    
    private lazy var likeCountLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray70)
    }
    
    private lazy var bottomLineView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(contentLabel)
        contentView.addSubview(postContainerView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(bottomLineView)
        
        postContainerView.addSubview(postTypeLabel)
        postContainerView.addSubview(postTitleLabel)
        
        contentLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        postContainerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(moderate(10))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(42))
        }
        
        postTypeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        postTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(postTypeLabel.snp.trailing).offset(moderate(10))
            $0.trailing.equalToSuperview().inset(moderate(10))
        }
        
        heartImageView.snp.makeConstraints {
            $0.top.equalTo(postContainerView.snp.bottom).offset(moderate(10))
            $0.leading.equalTo(postContainerView)
            $0.size.equalTo(moderate(17))
            $0.bottom.equalTo(bottomLineView.snp.top).offset(moderate(16.5))
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(heartImageView)
            $0.leading.equalTo(heartImageView.snp.trailing).offset(moderate(2))
        }
        
        bottomLineView.snp.makeConstraints {
            $0.bottom.leading.trailing.width.equalToSuperview()
            $0.height.equalTo(moderate(1))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ comment: LikedCommentData) {
        contentLabel.text = comment.content
        postTypeLabel.text = comment.articleType
        postTitleLabel.text = comment.articleTitle
        likeCountLabel.text = String(comment.likeCount)
    }
}
