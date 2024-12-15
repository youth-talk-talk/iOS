//
//  ResultDetailView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/19/24.
//

import UIKit

final class PostDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let nicknameLabel = UILabel()
    private let titleLabel = UILabel()
    private let policyLiteralLabel = UILabel()
    private let policyLabel = UILabel()
    private let contentLabel = UILabel()
    
    let commentTextFieldView = CommentTextFieldView()
    
    var data: [CommentDetailEntity] = []
    
    override func configureView() {
        
        flexView.backgroundColor = .clear
        
        nicknameLabel.designed(text: "닉네임", fontType: .p14Bold)
        titleLabel.designed(text: "제목", fontType: .p18Bold, textColor: .black)
        policyLiteralLabel.designed(text: "정책명", fontType: .p16Bold)
        policyLabel.designed(text: "정책명 --", fontType: .p12Regular)
    }
    
    lazy var commentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 17, bottom: 17, right: 17)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var commentTitleLabel = UILabel().then {
        $0.designed(text: "댓글", fontType: .g14Bold)
    }
    
    lazy var commentCountLabel = UILabel().then {
        $0.designed(text: "0", fontType: .g14Bold, textColor: .gray40)
    }
    
    override func configureLayout() {
        
        flexView.addSubview(scrollView)
        flexView.addSubview(commentTextFieldView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            nicknameLabel,
            titleLabel,
            policyLiteralLabel,
            policyLabel,
            contentLabel,
            commentTitleLabel,
            commentCountLabel,
            commentStackView
        ])
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(commentTextFieldView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel)
        }
        
        policyLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel)
        }
        
        policyLabel.snp.makeConstraints {
            $0.leading.equalTo(policyLiteralLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalTo(policyLiteralLabel)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(policyLiteralLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(17)
        }
        
        commentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.leading.equalTo(nicknameLabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentTitleLabel)
            $0.leading.equalTo(commentTitleLabel.snp.trailing).offset(4)
        }
        
        commentStackView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(commentTitleLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        commentTextFieldView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
    
    func configure(data: DetailRPEntity, complete: @escaping () -> Void) {
        let nickname = data.nickname ?? "익명"
        let policyTitle = data.policyTitle ?? "-"
        
        nicknameLabel.designed(text: nickname, fontType: .p14Bold)
        titleLabel.designed(text: data.title, fontType: .p18Bold, textColor: .black)
        policyLiteralLabel.designed(text: "정책명", fontType: .p16Bold)
        policyLabel.designed(text: policyTitle, fontType: .p12Regular)
        policyLabel.numberOfLines = 1
        policyLabel.lineBreakMode = .byTruncatingTail
        
        if data.contentList.isEmpty {
            
            contentLabel.designed(text: data.content, fontType: .p14Regular)
            contentLabel.numberOfLines = 0
            
            complete()
        } else {
            FontManager.imageWithText(contentList: data.contentList, fontType: .p14Regular, textColor: .black) { [weak self] attributeString in
                
                guard let self else { return }
                
                contentLabel.attributedText = attributeString
                contentLabel.numberOfLines = 0
                
                complete()
            }
        }
    }
}

final class CommentView: UIView {
    let commentId: Int
    var isLiked: Bool
    
    private lazy var userNameLabel = UILabel().then {
        $0.font = FontManager.font(.p12Bold)
        $0.textColor = .black
    }
    
    lazy var commentLabel = UILabel().then {
        $0.font = FontManager.font(.p12Regular)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    lazy var editLabel = UILabel().then {
        $0.designed(text: "수정", fontType: .p10Regular, textColor: .gray40)
    }
    
    lazy var deleteLabel = UILabel().then {
        $0.designed(text: "삭제", fontType: .p10Regular, textColor: .gray40)
    }
    
    lazy var likeImageView = UIImageView(image: UIImage(named: "like"))
    
    init(userName: String, commentId: Int,  comment: String, isItOwnComment: Bool, isLiked: Bool) {
        self.commentId = commentId
        self.isLiked = isLiked
        
        super.init(frame: .zero)
        
        layer.cornerRadius = 4
        backgroundColor = .white
        layer.shadowColor = FontColor.black.value.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        
        userNameLabel.text = (userName == "null") ? "익명" : userName
        commentLabel.text = comment
        likeImageView.image = isLiked ? UIImage(named: "like_fill") : UIImage(named: "like")
        editLabel.isHidden = !isItOwnComment
        deleteLabel.isHidden = !isItOwnComment
        likeImageView.isHidden = isItOwnComment
        
        addSubviews([userNameLabel,
                     commentLabel,
                     editLabel,
                     deleteLabel,
                     likeImageView])
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        deleteLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(10)
        }
        
        editLabel.snp.makeConstraints {
            $0.trailing.equalTo(deleteLabel.snp.leading).offset(-5)
            $0.top.equalTo(deleteLabel)
        }
        
        likeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(13)
            $0.size.equalTo(16)
        }
    }
    
    func bind(userName: String, commentId: Int,  comment: String, isItOwnComment: Bool, isLiked: Bool) {
        userNameLabel.text = (userName == "null") ? "익명" : userName
        commentLabel.text = comment
        likeImageView.image = isLiked ? UIImage(named: "like_fill") : UIImage(named: "like")
        
        
        editLabel.isHidden = !isItOwnComment
        deleteLabel.isHidden = !isItOwnComment
        likeImageView.isHidden = isItOwnComment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
