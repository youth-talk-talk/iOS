//
//  PostImageView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/21/24.
//

import UIKit

final class PostImageView: UIView {
    
    lazy var imageView = UIImageView()
    
    lazy var deleteBackView = UIView()
    
    private lazy var deleteImageView = UIImageView(image: UIImage(named: "littleXmark"))
    
    init(image: UIImage) {
        super.init(frame: .zero)
        
        imageView.image = image
        
        addSubview(imageView)
        addSubview(deleteBackView)
        deleteBackView.addSubview(deleteImageView)
        
        deleteBackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        deleteImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
