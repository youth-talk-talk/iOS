//
//  EditMyInfoViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/6/25.
//

import UIKit

final class EditMyInfoViewController: RootViewController {
    
    private let viewModel: MyPageViewModel
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "내 계정", font: .p18Semi)
    }
    
    private let saveLabel = UILabel().then {
        $0.designed(text: "저장", font: .p12Regular, textColor: .green)
    }
    
    private let profileImageView = UIImageView(image: .profileLogo)
    
    private let photoImageView = UIImageView(image: .camera)
    
    private let nameLabel = UILabel().then {
        $0.designed(text: "닉네임", font: .p14Regular, textColor: .gray90)
    }
    
    private let nameView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
        $0.font = FontManager.font(.p16Regular16)
    }
    
    private let regionLabel = UILabel().then {
        $0.designed(text: "관심 지역", font: .p14Regular, textColor: .gray90)
    }
    
    private let regionView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let regionSelectLabel = UILabel().then {
        $0.designed(text: "지역을 선택해 주세요.", font: .p16Regular16)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    private let logoutLabel = UILabel().then {
        $0.designed(text: "로그아웃", font: .p14Regular, textColor: .gray70)
    }
    
    private let regionArrowImageView = UIImageView().then {
        $0.image = .arrowDown
    }
    
    init(_ myInfo: MeDTO, _ viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        nameTextField.text = myInfo.data.nickname
        regionSelectLabel.text = myInfo.data.region
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutLabel.onTapped {
            // MARK: 로그아웃 전 토큰 제거
            let keyChainHelper = KeyChainHelper()
            
            keyChainHelper.deleteTokenInfo(type: .accessToken)
            keyChainHelper.deleteTokenInfo(type: .refreshToken)
            
            // MARK: 로그인 페이지로 이동
            let uc = SignInUseCaseImpl()
            let vm = SignInViewModel(signInUseCase: uc)
            let vc = SignInViewController(viewModel: vm)
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate else { return }

            let nav = UINavigationController(rootViewController: vc)
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }
        
        backImageView.onTapped { [weak self] in
            self?.showAlert(title: "프로필 편집 나가기",
                            content: "화면을 나가면 변경사항이 저장되지 않습니다.\n나가시겠습니까?",
                            cancelText: "나가기",
                            actionText: "편집하기",
                            onCancel: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        saveLabel.onTapped { [weak self] in
            self?.showAlert(title: "프로필 저장",
                            content: "변경된 내용을 저장하시겠습니까?",
                            cancelText: "닫기",
                            actionText: "저장하기",
                            onAction: { [weak self] in
                self?.viewModel.editMyInfo(nickname: self?.nameTextField.text,
                                           region: self?.regionSelectLabel.text ?? "서울",
                                           onSuccess: { [weak self] in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
        
        regionArrowImageView.onTapped { [weak self] in
            guard let self else { return }
            
            let vc = RegionBottomSheetViewController(selectedRegion: regionSelectLabel.text,
                                                     onRegionTapped: { [weak self] selectedRegion in
                self?.regionSelectLabel.text = selectedRegion?.networkName
            })
            
            if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
            
            present(vc, animated: true, completion: nil)
        }
        
        view.addSubviews(titleLabel,
                         saveLabel,
                         profileImageView,
                         nameLabel,
                         nameView,
                         regionLabel,
                         regionView,
                         dividerView,
                         logoutLabel)
        
        nameView.addSubview(nameTextField)
        
        regionView.addSubview(regionSelectLabel)
        regionView.addSubview(regionArrowImageView)
        
        profileImageView.addSubview(photoImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        saveLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(29))
            $0.size.equalTo(moderate(94))
        }
        
        photoImageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(moderate(20))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        nameView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(nameLabel.snp.bottom).offset(moderate(12))
        }
        
        nameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameView)
            $0.top.equalTo(nameView.snp.bottom).offset(moderate(20))
        }
        
        regionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(regionLabel.snp.bottom).offset(moderate(12))
        }
        
        regionSelectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(12))
            $0.trailing.equalTo(regionArrowImageView.snp.leading)
        }
        
        regionArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(20))
            $0.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(1)
            $0.top.equalTo(regionView.snp.bottom).offset(moderate(30))
        }
        
        logoutLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(20))
        }
    }
}
