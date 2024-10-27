//
//  ResultDetailView.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/19/24.
//

import UIKit
import FlexLayout
import PinLayout

class ResultDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nicknameLabel = UILabel()
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
        commentTitleLabel.designed(text: "댓글", fontType: .p14Bold)
    }
    
    override func configureLayout() {
        
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        flexView.flex.define { flex in
            
            flex.addItem(scrollView)
                .width(100%)
                .grow(1)
            
            flex.addItem(commentTextFieldView)
                .width(100%)
                .height(64)
        }
        
        contentView.flex.define { flex in
            
            flex.addItem()
                .height(15)
            
            flex.addItem(nicknameLabel)
            
            flex.addItem()
                .height(3)
            
            flex.addItem(titleLabel)
            
            flex.addItem()
                .height(12)
            
            flex.addItem().define { row in
                
                row.addItem(policyLiteralLabel)
                
                row.addItem()
                    .width(12)
                
                row.addItem(policyLabel)
                    .grow(1)
                    .markDirty()
            }
            .direction(.row)
            .alignItems(.center)
            .width(100%)
            
            flex.addItem()
                .height(12)
            
            flex.addItem(contentLabel)
                .width(100%)
        }
        .marginHorizontal(17)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // contentView의 높이를 다시 계산하고 적용
        contentView.flex.layout(mode: .adjustHeight)
        
        // scrollView의 contentSize를 contentView의 프레임 크기로 설정
        scrollView.contentSize = contentView.frame.size
        
        // commentTextFieldView와 flexView의 높이 계산
        let commentHeight = commentTextFieldView.frame.height
        let availableHeight = flexView.frame.height - commentHeight - 1
        scrollView.flex.height(availableHeight)
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
            contentLabel.flex.layout(mode: .adjustHeight)
            flexView.flex.layout()
            
            complete()
        } else {
            FontManager.imageWithText(contentList: data.contentList, fontType: .p14Regular, textColor: .black) { [weak self] attributeString in
                
                guard let self else { return }
                
                contentLabel.attributedText = attributeString
                contentLabel.numberOfLines = 0
                contentLabel.flex.layout(mode: .adjustHeight)
                flexView.flex.layout()
                
                complete()
            }
        }
    }
    
    func comment(data: [CommentDetailEntity]) {
        
    }
}
