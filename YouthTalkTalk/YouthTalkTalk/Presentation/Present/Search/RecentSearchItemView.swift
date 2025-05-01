//
//  RecentSearchItemView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/28/25.
//

import UIKit

final class RecentSearchItemView: UIView {
    private let recentImageView = UIImageView(image: .time)
    
    private let searchTextLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.designed(font: .p16Regular16, textColor: .gray90)
    }
    
    let xImageView = UIImageView(image: .xmark)
    
    init(text: String) {
        super.init(frame: .zero)
        
        searchTextLabel.text = text
        
        addSubviews([recentImageView,
                     searchTextLabel,
                     xImageView])
        
        recentImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
        
        searchTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recentImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(xImageView.snp.leading).offset(-10)
        }
        
        xImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
