//
//  RootViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit

class RootViewController: UIViewController {
    
    private(set) var backImageView = UIImageView(image: .back)
    private(set) var xImageView = UIImageView(image: .littleXmark).then {
        $0.isHidden = true
    }
    
    private let titleLabel = UILabel().then {
        $0.designed(font: .p18Semi)
    }
    
    // MARK: 얼럿
    private let alertDimView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    private let alertView = UIView().then {
        $0.layer.cornerRadius = moderate(10)
        $0.backgroundColor = .white
    }
    
    private let alertTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(8)
    }
    
    private let alertTitleLabel = UILabel().then {
        $0.designed(font: .p16SemiBold)
        $0.numberOfLines = 0
    }
    
    private let alertContentLabel = UILabel().then {
        $0.designed(font: .p14Regular)
        $0.numberOfLines = 0
    }
    
    private let alertButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.distribution = .fillEqually
    }
    
    private let alertCancelButton = UILabel().then {
        $0.designed(text: "닫기", font: .p16Regular16)
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderate(6)
        $0.textAlignment = .center
        $0.clipsToBounds = true
    }
    
    private let alertActionButton = UILabel().then {
        $0.designed(text: "저장하기", font: .p16Regular16, textColor: .white)
        $0.backgroundColor = .greenNormal
        $0.layer.cornerRadius = moderate(6)
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.backgroundColor = .white
        
        view.addSubview(backImageView)
        view.addSubview(titleLabel)
        view.addSubview(xImageView)
        
        backImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(moderate(33))
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.size.equalTo(moderate(24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backImageView)
        }
        
        xImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.size.equalTo(moderate(24))
        }
        
        backImageView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        xImageView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setMenuTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func showAlert(title: String,
                   content: String,
                   cancelText: String? = nil,
                   actionText: String? = nil,
                   actionColor: UIColor = .greenNormal,
                   onCancel: (() -> Void)? = nil,
                   onAction: (() -> Void)? = nil) {
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        alertActionButton.backgroundColor = actionColor
        
        if alertDimView.superview == nil {
            window.addSubview(alertDimView)
            alertDimView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            setAlertLayout()
        } else {
            window.bringSubviewToFront(alertDimView)
        }

        alertTitleLabel.text = title
        alertContentLabel.text = content
        
        if let actionText = actionText {
            alertActionButton.text = actionText
        }
        
        if let cancelText = cancelText {
            alertCancelButton.text = cancelText
        }

        alertCancelButton.onTapped { [weak self] in
            self?.alertDimView.removeFromSuperview()
            onCancel?()
        }
        
        alertActionButton.onTapped { [weak self] in
            self?.alertDimView.removeFromSuperview()
            onAction?()
        }
    }
    
    private func setAlertLayout() {
        alertDimView.addSubview(alertView)
        
        alertView.addSubviews([alertTextStackView,
                               alertButtonStackView])
        
        alertTextStackView.addArrangedSubview(alertTitleLabel)
        alertTextStackView.addArrangedSubview(alertContentLabel)
        
        alertButtonStackView.addArrangedSubview(alertCancelButton)
        alertButtonStackView.addArrangedSubview(alertActionButton)
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        alertTextStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderate(24))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        alertButtonStackView.snp.makeConstraints {
            $0.top.equalTo(alertTextStackView.snp.bottom).offset(moderate(16))
            $0.leading.trailing.equalTo(alertTextStackView)
            $0.bottom.equalToSuperview().inset(moderate(24))
            $0.height.equalTo(moderate(46))
        }
    }
    
    func goLoginPage() {
        // MARK: 로그아웃/탈퇴 전 토큰 제거
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
}
