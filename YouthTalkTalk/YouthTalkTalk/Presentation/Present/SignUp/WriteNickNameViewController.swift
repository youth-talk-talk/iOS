//
//  WriteNickNameViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit
import RxCocoa
import RxSwift

final class WriteNickNameViewController: RootViewController {
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.designed(text: "반가워요!\n어떤 닉네임으로 불러드릴까요?", font: .p18Semi)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.designed(text: "청년톡톡에서 활동하실 닉네임을 정해주세요", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var nickNameTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "닉네임을 입력해 주세요.", font: .p16Regular16)
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray50.value.cgColor
        $0.delegate = self
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 12, $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.tintColor = .gray100
    }
    
    private let nextButton = UIButton().then {
        $0.designed(title: "다음")
        $0.isEnabled = false
    }
    
    init(viewModel: SignUpInterface) {
//        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        nickNameTextField.snp.makeConstraints {
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
    
    override func bind() {
//        
//        layoutView.pullDownTableView.delegate = self
//        layoutView.pullDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        
//        guard let gesture = layoutView.regionDropDownView.gestureRecognizers?.first else { return }
//        
//        // Dropdown(tableview) visible/hidden 토글
//        gesture.rx.event
//            .bind(with: self) { owner, _ in
//                
//                owner.layoutView.toggleTableViewHidden()
//                
//            }.disposed(by: disposeBag)
//
//        
//        // MARK: Inputs
//        layoutView.pullDownTableView.rx.itemSelected
//            .bind(to: viewModel.itemSelectedEvent)
//            .disposed(by: disposeBag)
//        
//        Observable.combineLatest(layoutView.regionDropDownView.regionDropdownLabel.rx.textChanged.asObservable(),
//                       layoutView.nicknameTextField.rx.text.asObservable(),
//                       layoutView.signUpButton.rx.tap.asObservable())
//        .subscribe(with: self) { owner, data in
//            
//            let (region, nickname, _) = data
//            
//            guard let region, let nickname else { return }
//            
//            if region == "" || nickname == "" {
//                
//                owner.viewModel.input.signUpButtonInvalid.accept(())
//                return
//            }
//            
//            let userData = (region, nickname)
//            
//            owner.viewModel.input.signUpButtonClicked.accept(userData)
//            
//        }.disposed(by: disposeBag)
//        
//        // MARK: Ouputs
//        // Configure Cell
//        viewModel.output.policyLocations
//            .drive(layoutView.pullDownTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, location, cell in
//                
//                cell.textLabel?.designed(text: location.displayName, fontType: .p16Regular16, textColor: .gray40)
//                cell.backgroundColor = .clear
//                
//            }.disposed(by: disposeBag)
//        
//        // Selected Item
//        viewModel.output.selectedLocation
//            .drive(with: self) { owner, policyLocation in
//                
//                owner.layoutView.updateLocation(policyLocation)
//                
//            }.disposed(by: disposeBag)
//        
//        viewModel.output.signUp
//            .drive(with: self) { owner, isSignUp in
//                
//                if isSignUp {
//                    SceneDelegate.makeRootVC()
//                } else {
//                }
//            }.disposed(by: disposeBag)
//        
//        // 이벤트 전달
//        viewModel.input.policyLocationRelay.accept(())
    }
}

extension WriteNickNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nickNameTextField.layer.borderColor = FontColor.gray100.value.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        nickNameTextField.layer.borderColor = FontColor.gray50.value.cgColor
    }
}
