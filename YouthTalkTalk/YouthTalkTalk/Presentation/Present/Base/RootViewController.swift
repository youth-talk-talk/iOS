//
//  RootViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit

class RootViewController: UIViewController {
    
    private(set) var backImageView = UIImageView(image: .back)
    
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
    }
    
    private let alertContentLabel = UILabel().then {
        $0.designed(font: .p14Regular)
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
        
        backImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(33)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backImageView)
        }
        
        backImageView.onTapped { [weak self] in
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
                   onCancel: (() -> Void)? = nil,
                   onAction: (() -> Void)? = nil) {
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        
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
}
