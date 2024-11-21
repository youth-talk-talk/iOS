//
//  PostImageView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/21/24.
//

import UIKit
 
final class PostImageView: UIImageView {
    private lazy var deleteImageView = UIImageView(image: UIImage(named: "littleXmark"))
    override init(image: UIImage?) {
        super.init(image: image)
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        addSubview(deleteImageView)
        
        deleteImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
