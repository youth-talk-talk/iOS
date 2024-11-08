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
    private lazy var shadowView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private lazy var backView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
    }
    
    private lazy var noticeImageView = UIImageView(image: UIImage(named: "notice"))
    
    private lazy var titleLabel = UILabel().then {
        $0.font = FontManager.font(.p18Regular)
        $0.textColor = FontColor.black.value
        $0.textAlignment = .center
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
        $0.titleLabel?.textColor = FontColor.black.value
    }
    
    private lazy var okButton = UIButton().then {
        $0.backgroundColor = .lime40
        $0.layer.cornerRadius = 25
        $0.setTitle("예", for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.titleLabel?.textColor = FontColor.black.value
    }
    
    init(title: String, okAction: () -> Void) {
        super.init(frame: .zero)
        
        layout()
        setTabEvents(okAction)

        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTabEvents(_ okAction: () -> ()) {
        cancelButton.onTapped { [weak self] in
            self?.removeFromSuperview()
        }
        
        
    }
    
    private func layout() {
        addSubview(shadowView)
        shadowView.addSubview(backView)
        backView.addSubview(noticeImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(buttonStackView)
        
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(240)
            $0.center.equalToSuperview()
        }
        
        noticeImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().inset(36)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(17)
            $0.centerX.equalToSuperview()
        }
    }
}
