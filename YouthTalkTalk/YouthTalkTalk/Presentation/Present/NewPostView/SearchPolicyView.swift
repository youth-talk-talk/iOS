//
//  SearchPolicyView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/19/24.
//

import UIKit
import SnapKit

final class SearchPolicyView: UIView {
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = FontManager.font(.g20Bold)
        $0.textColor = FontColor.gray60.value
        $0.text = "정책검색"
    }
    
    private lazy var closeButton = UIImageView(image: UIImage(named: "littleXmark"))
    
    private lazy var textFieldBackgroundView = UIView().then {
        $0.backgroundColor = FontColor.gray10.value
        $0.layer.cornerRadius = 25
    }
    
    private lazy var policyTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "정책명을 검색해주세요", font: .p16Regular16)
    }
    
    private lazy var searchIconImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
    
    private lazy var policyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private lazy var addButton = UILabel().then {
        $0.backgroundColor = .lime40
        $0.text = "추가하기"
        $0.textAlignment = .center
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.textColor = .black
        $0.font = FontManager.font(.p16Regular16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.5)
        
        layout()
        addTapEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTapEvents() {
        closeButton.onTapped { [weak self] in
            self?.isHidden = true
        }
    }
    
    private func layout() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(textFieldBackgroundView)
        containerView.addSubview(policyCollectionView)
        containerView.addSubview(addButton)
        
        textFieldBackgroundView.addSubview(policyTextField)
        textFieldBackgroundView.addSubview(searchIconImageView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(525)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textFieldBackgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        policyTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(searchIconImageView.snp.leading).offset(-10)
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
        policyCollectionView.backgroundColor = .red
        policyCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(textFieldBackgroundView.snp.bottom).offset(20)
            $0.bottom.equalTo(addButton.snp.top).offset(-20)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(27)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
}
