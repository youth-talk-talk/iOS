//
//  SettingNicknameViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 2/4/25.
//

import UIKit

final class SettingNicknameViewController: UIViewController {
    private let originName: String
    private let completeChangedMeData: (PatchMeDataDTO) -> Void

    private let viewModel = SettingViewModel()
    
    private let backImageView = UIImageView(image: .back.withRenderingMode(.alwaysOriginal))

    private let nicknameLabel = UILabel().then {
        $0.designed(text: "닉네임 설정", fontType: .g14Bold)
    }
    
    private let nicknameTextFieldBgView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.gray30.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let nicknameTextField = UITextField().then {
        $0.font = FontManager.font(.p16Regular16)
        $0.addTarget(self,
                     action: #selector(nicknameFieldDidChange),
                     for: .editingChanged)
    }
    
    private let applyButton = UIButton().then {
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.backgroundColor = .gray20
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    init(originName: String,
         completeChangedMeData: @escaping (PatchMeDataDTO) -> Void) {
        self.originName = originName
        self.completeChangedMeData = completeChangedMeData
        
        nicknameTextField.text = originName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewModel.onSavedInfo = { [weak self] changedInfo in
            self?.completeChangedMeData(changedInfo)
            self?.navigationController?.popViewController(animated: true)
        }
        
        applyButton.onTapped { [weak self] in
            guard let self else { return }
            
            if nicknameTextField.isNotEmpty(), let nickname = nicknameTextField.text {
                viewModel.writtenNickName = nickname
                viewModel.saveChangedInfo()
            }
        }
        
        view.addSubview(backImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextFieldBgView)
        view.addSubview(applyButton)
        nicknameTextFieldBgView.addSubview(nicknameTextField)
        
        backImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(18)
        }
        
        nicknameTextFieldBgView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(103)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func nicknameFieldDidChange() {
        applyButton.backgroundColor = (nicknameTextField.isNotEmpty() && originName != nicknameTextField.text) ? .lime40 : .gray20
    }
}
