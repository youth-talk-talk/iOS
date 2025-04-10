//
//  SelectRegionViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/9/25.
//

import UIKit

final class SelectRegionViewController: RootViewController {
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.designed(text: "지역을 선택해 주세요", font: .p18Semi)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.designed(text: "지역을 기반으로 다양한 정책을 추천해 드려요", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var regionTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "지역을 선택해 주세요.", font: .p16Regular16)
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray50.value.cgColor
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.tintColor = .gray100
        $0.makeLeftPaddingView()
        
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 32, height: 20))
        let imageView = UIImageView(image: .arrowDown)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        paddingView.addSubview(imageView)
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    
    private let nextButton = UIButton().then {
        $0.designed(title: "완료하기")
        $0.isEnabled = false
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        regionTextField.onTapped { [weak self] in
            let vc = RegionBottomSheetViewController(onRegionTapped: { [weak self] selectedRegion in
                self?.regionTextField.text = selectedRegion
                self?.nextButton.isEnabled = selectedRegion != nil
            })
            
            if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
            
            self?.present(vc, animated: true, completion: nil)
        }
        
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(regionTextField)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        regionTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let hasText = !(textField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
        nextButton.isEnabled = hasText
    }
}
