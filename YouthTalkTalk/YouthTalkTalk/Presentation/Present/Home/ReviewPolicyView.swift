//
//  ReviewPolicyView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/27/25.
//

import UIKit
import Kingfisher

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
        $0.contentMode = .scaleAspectFit
    }
    
    private let reviewPolicyArrowImageView = UIImageView(image: .rightArrowCircle)
    
    private let reviewPolicyLabel = UILabel().then {
        $0.designed(text: "정책 타이틀입니다.", font: .p16SemiBold)
        $0.numberOfLines = 2
    }
    
    private let reviewPostStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(20)
    }
    
    private let morePolicyView = UIView().then {
        $0.backgroundColor = .gray20
        $0.layer.cornerRadius = moderate(6)
    }
    
    private let morePolicyTitleLabel = UILabel().then {
        $0.designed(text: "새로운 정책 더보기", font: .p14Regular)
    }
    
    private let morePolicyCountLabel = UILabel().then {
        $0.designed(font: .p14Regular)
    }
    
    private var currentPolicyIndex = 0
    private var policyWithReviews: [PolicyWithReviewsDTO] = []
    
    private let morePolicyImageView = UIImageView(image: .refresh.withTintColor(.gray100))
    
    init() {
        super.init(frame: .zero)
        
        morePolicyView.onTapped { [weak self] in
            guard let self else { return }
            
            currentPolicyIndex = currentPolicyIndex == policyWithReviews.count - 1 ? 0 : currentPolicyIndex + 1
            morePolicyCountLabel.text = "\(currentPolicyIndex + 1)/\(policyWithReviews.count)"
            
            setData()
        }
        
        addSubviews([reviewPolicyTitleLabel,
                     reviewPolicyBaseView])
        
        reviewPolicyBaseView.addSubviews([reviewPolicyImageView,
                                          reviewPolicyLabel,
                                          reviewPolicyArrowImageView,
                                          reviewPostStackView,
                                          morePolicyView])
        
        morePolicyView.addSubviews(morePolicyImageView,
                                   morePolicyTitleLabel,
                                   morePolicyCountLabel)
        
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
        
        reviewPostStackView.snp.makeConstraints {
            $0.top.equalTo(reviewPolicyImageView.snp.bottom).offset(moderate(35))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalTo(morePolicyView.snp.top).offset(moderate(-10))
        }
        
        morePolicyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalToSuperview().inset(moderate(24))
            $0.height.equalTo(moderate(46))
        }
        
        morePolicyTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        morePolicyImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(16))
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(morePolicyTitleLabel.snp.leading).offset(moderate(-10))
        }
        
        morePolicyCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(morePolicyTitleLabel.snp.trailing).offset(moderate(4))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(policyWithReviews: [PolicyWithReviewsDTO]) {
        self.policyWithReviews = policyWithReviews
        
        setData()
        
        morePolicyCountLabel.text = "1/\(policyWithReviews.count)"
    }
    
    private func setData() {
        guard policyWithReviews.count > currentPolicyIndex else { return }

        let policyWithReviews = policyWithReviews[currentPolicyIndex]
        
        reviewPostStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            reviewPostStackView.removeArrangedSubview(view)
        }

        reviewPolicyLabel.text = policyWithReviews.title
        
        if policyWithReviews.departmentImgUrl == "default" || policyWithReviews.departmentImgUrl == nil {
            reviewPolicyImageView.image = .govermentNull
        } else {
            reviewPolicyImageView.kf.setImage(with: URL(string: policyWithReviews.departmentImgUrl!))
        }
        
        policyWithReviews.reviews.enumerated().forEach { index, review in
            let postView = ReviewPostView(post: review)
            postView.dividerLine.isHidden = (policyWithReviews.reviews.count == index + 1)
            reviewPostStackView.addArrangedSubview(postView)
        }
    }
}

final class ReviewPostView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.designed(font: .p16Regular16)
        $0.numberOfLines = 1
    }
    
    private let contentLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray80)
        $0.numberOfLines = 1
    }
    
    private let commentImageView = UIImageView(image: .comments.withTintColor(.gray80))
    private let commentCountLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray80)
    }
    
    private let scrapImageView = UIImageView(image: .bookmarkLine)
    private let scrapCountLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray80)
    }
    
    private let dateLabel = UILabel().then {
        $0.designed(font: .p12Regular, textColor: .gray80)
    }
    
    let dividerLine = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    init(post: ReviewDTO) {
        super.init(frame: .zero)
        
        titleLabel.text = post.title
        contentLabel.text = post.contentPreview
        commentCountLabel.text = String(post.commentCount)
        scrapCountLabel.text = String(post.scrapCount)
        dateLabel.text = post.createdAt
        
        addSubviews([
            titleLabel, contentLabel,
            commentImageView, commentCountLabel,
            scrapImageView, scrapCountLabel,
            dateLabel,
            dividerLine
        ])
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(4))
            $0.leading.trailing.equalToSuperview()
        }
        
        commentImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(moderate(16))
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(dividerLine.snp.top).inset(moderate(-20))
            $0.size.equalTo(moderate(16))
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderate(2))
        }
        
        scrapImageView.snp.makeConstraints {
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(moderate(10))
            $0.centerY.equalTo(commentImageView)
            $0.size.equalTo(moderate(16))
        }
        
        scrapCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(scrapImageView.snp.trailing).offset(moderate(2))
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.trailing.equalToSuperview()
        }
        
        dividerLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(moderate(1))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
