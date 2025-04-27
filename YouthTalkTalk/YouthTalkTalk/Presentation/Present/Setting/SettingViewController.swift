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
        
//        viewModel.output.successDeleteAccount.bind { [weak self] _ in
//            self?.goSignInView()
//        }
//        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    
//    override func configureView() {
//        
//        view.backgroundColor = .white
//        
//        nicknameLabel.designed(text: "닉네임 설정", font: .g14Bold)
//        nicknameButtonView.setTitle(data.nickname)
//        nicknameButtonView.setImage(.edit)
//        
//        nicknameButtonView.imageButton.onTapped { [weak self] in
//            guard let self else { return }
//            
//            let vc = SettingNicknameViewController(originName: data.nickname,
//                                                   completeChangedMeData: { [weak self] newMeData in
//                self?.nicknameButtonView.setTitle(newMeData.nickname)
//            })
//            
//            navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        regionLabel.designed(text: "나의 지역설정", font: .g14Bold)
//        regionButtonView.setTitle(data.region)
//        regionButtonView.setImage(.setting)
//        
//        regionButtonView.imageButton.onTapped { [weak self] in
//            let vc = SettingRegionViewController(completeChangedMeData: { [weak self] newMeData in
//                self?.regionButtonView.setTitle(newMeData.region)
//            })
//            
//            self?.present(vc, animated: true)
//        }
//        
//        logoutLabel.onTapped { [weak self] in
//            self?.goSignInView()
//        }
//        
//        withdrawLabel.onTapped { [weak self] in
//            let alertView = TwoButtonAlertView(title: "정말로 탈퇴 하시겠습니까?") { [weak self] in
//                self?.viewModel.input.deleteAccount.accept(())
//            }
//            
//            self?.view.addSubview(alertView)
//            
//            alertView.snp.makeConstraints {
//                $0.edges.equalToSuperview()
//            }
//        }
//        
//        logoutLabel.designed(text: "로그아웃", font: .p16SemiBold, textColor: .gray60)
//        withdrawLabel.designed(text: "회원탈퇴", font: .p16SemiBold, textColor: .gray60)
//    }
    
    private func goSignInView() {
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
}
