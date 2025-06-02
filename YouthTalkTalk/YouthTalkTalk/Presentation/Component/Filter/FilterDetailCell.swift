//
//  FilterDetailCell.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/2/25.
//

import UIKit
import SnapKit
import Then

final class FilterDetailCell: UICollectionViewCell {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = FontManager.font(.p14Regular)
        $0.textColor = .gray80
    }

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(
      _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
      let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
      attributes.frame.size.width = calculateTagSize(to: layoutAttributes)
      return attributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupRadius()
    }
    
    // MARK: - SetupUI
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func setupStyle() {
        contentView.layer.borderColor = UIColor.gray40.cgColor
        contentView.layer.borderWidth = 1
    }
    
    // MARK: - Configue
    func configure(with model: FilterDetailItem) {
        self.titleLabel.text = model.title
        
        if model.isSelected {
            contentView.backgroundColor = .greenNormal
            titleLabel.textColor = .gray10
            contentView.layer.borderWidth = 0
        } else {
            contentView.backgroundColor = .gray10
            titleLabel.textColor = .gray80
            contentView.layer.borderWidth = 1
        }
    }
    
    // MARK: - Private
    // label text가 길어져서 cell width가 최대 지정 width를 넘어간다면, cell width를 고정해줍니다.
    private func calculateTagSize(
      to layoutAttributes: UICollectionViewLayoutAttributes
    ) -> Double {
      let targetSize = CGSize(width: layoutAttributes.size.width, height: 32)

      // 현재 제약조건으로부터 가장 적절한 size를 계산합니다.
      let optimalSize = contentView.systemLayoutSizeFitting(
        targetSize,
        withHorizontalFittingPriority: .fittingSizeLevel,
        verticalFittingPriority: .required
      )

      // cell width가 최대 width를 넘어가면, cell width를 최대 width로 지정합니다.
      return min(optimalSize.width, UIScreen.main.bounds.width - 26)
    }
    
    private func setupRadius() {
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.contentView.layer.masksToBounds = true
    }
}
