//
//  SettingViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/31/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class SettingViewController: RootViewController {
    
    private let viewModel: MyPageInterface
    
    let nicknameLabel = UILabel()
    let nicknameButtonView = TitleWithImageButtonView()
    
    let regionLabel = UILabel()
    let regionButtonView = TitleWithImageButtonView()
    
    let logoutLabel = UILabel()
    let withdrawLabel = UILabel()
    
    private let data: MeEntity
    
    init(data: MeEntity, viewModel: MyPageInterface) {
        self.data = data
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        
        view.backgroundColor = .white
        
        nicknameLabel.designed(text: "닉네임 설정", fontType: .g14Bold)
        nicknameButtonView.setTitle(data.nickname)
        nicknameButtonView.setImage(.edit)
        
        regionLabel.designed(text: "나의 지역설정", fontType: .g14Bold)
        regionButtonView.setTitle(data.region)
        regionButtonView.setImage(.setting)
        
        logoutLabel.onTapped {
            let useCase = SignInUseCaseImpl()
            let viewModel = SignInViewModel(signInUseCase: useCase)
            let newRootVC = SignInViewController(viewModel: viewModel)
            let naviVC = UINavigationController(rootViewController: newRootVC)
            
            let keyChainHelper = KeyChainHelper()
            keyChainHelper.deleteTokenInfo(type: .accessToken)
            keyChainHelper.deleteTokenInfo(type: .refreshToken)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                    fatalError("Failed to get SceneDelegate")
                }
                sceneDelegate.window?.rootViewController = naviVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
        
        withdrawLabel.onTapped { [weak self] in
            let alertView = TwoButtonAlertView(title: "정말로 탈퇴 하시겠습니까?") { [weak self] in
                // TODO: 탈퇴 로직 구현
            }
            
            self?.view.addSubview(alertView)
            
            alertView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        logoutLabel.designed(text: "로그아웃", fontType: .p16SemiBold, textColor: .gray60)
        withdrawLabel.designed(text: "회원탈퇴", fontType: .p16SemiBold, textColor: .gray60)
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem(nicknameLabel)
                .marginTop(29)
                .width(100%)
            
            flex.addItem(nicknameButtonView)
                .marginTop(12)
                .width(100%)
                .height(50)
            
            flex.addItem(regionLabel)
                .marginTop(29)
                .width(100%)
            
            flex.addItem(regionButtonView)
                .marginTop(12)
                .width(100%)
                .height(50)
            
            flex.addItem(logoutLabel)
                .marginTop(24)
                .width(100%)
                .height(50)
            
            flex.addItem(withdrawLabel)
                .width(100%)
                .height(50)
            
        }
        .marginHorizontal(17)
    }
    
    override func bind() {
        
        regionButtonView.imageButton.rx.tap
            .bind(with: self) { owner, _ in
                //
            }
            .disposed(by: disposeBag)
    }
}
