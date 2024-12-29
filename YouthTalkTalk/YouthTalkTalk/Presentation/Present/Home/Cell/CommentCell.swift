//
//  CommentCell.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 12/11/24.
//

import UIKit

final class CommentCell: UICollectionViewCell {
    lazy var commentView = CommentView(userName: "",
                                       commentId: 0,
                                       comment: "",
                                       isItOwnComment: false,
                                       isLiked: true)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(commentView)
        
        commentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(userName: String,
              commentId: Int,
              comment: String,
              isItOwnComment: Bool,
              isLiked: Bool) {
        commentView.bind(userName: userName,
                         commentId: commentId,
                         comment: comment,
                         isItOwnComment: isItOwnComment,
                         isLiked: isLiked)
    }
}
