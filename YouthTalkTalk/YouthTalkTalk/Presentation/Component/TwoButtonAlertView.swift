//
//  TwoButtonAlertView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class TwoButtonAlertView: UIView {
    private var okAction: (() -> Void)?
    
    private lazy var shadowView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
        $0.alignment = .center
        $0.layoutMargins = UIEdgeInsets(top: 36, left: 0, bottom: 17, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var noticeImageView = UIImageView(image: UIImage(named: "notice"))
    
    private lazy var titleLabel = UILabel().then {
        $0.font = FontManager.font(.p18Regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [cancelButton, okButton]).then {
        $0.spacing = 13
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.backgroundColor = FontColor.gray20.value
        $0.layer.cornerRadius = 25
        $0.setTitle("아니요", for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var okButton = UIButton().then {
        $0.backgroundColor = .lime40
        $0.layer.cornerRadius = 25
        $0.setTitle("예", for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.setTitleColor(.black, for: .normal)
    }
    
    init(title: String, okAction: @escaping () -> Void) {
        self.okAction = okAction
        
        super.init(frame: .zero)
        
        layout()
        setTabEvents()

        titleLabel.text = title
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String, okAction: @escaping () -> Void) {
        titleLabel.text = title
        self.okAction = okAction
        
        layout()
        setTabEvents()
    }
    
    private func setTabEvents() {
        cancelButton.onTapped { [weak self] in
            self?.removeFromSuperview()
        }
        
        okButton.onTapped { [weak self] in
            self?.okAction?()
            self?.removeFromSuperview()
        }
    }
    
    private func layout() {
        addSubview(shadowView)
        shadowView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(noticeImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(buttonStackView)
        
        containerStackView.setCustomSpacing(20, after: noticeImageView)
        containerStackView.setCustomSpacing(29, after: titleLabel)
        
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.center.equalToSuperview()
        }
        
        noticeImageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
    }
}
