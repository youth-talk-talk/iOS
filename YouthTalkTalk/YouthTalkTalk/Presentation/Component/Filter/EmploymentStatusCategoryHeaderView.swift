//
//  EmploymentStatusCategoryHeaderView.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

final class EmploymentStatusCategoryHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = FontManager.font(.p14SemiBold)
        $0.textColor = .gray100
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        // 스타일링 추가 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(text: String) {
        self.titleLabel.text = text
    }
}

