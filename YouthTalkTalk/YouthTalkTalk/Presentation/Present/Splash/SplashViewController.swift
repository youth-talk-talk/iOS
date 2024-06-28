//
//  SplashViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/27/24.
//

import UIKit
import RxCocoa

class SplashViewController: BaseViewController<SplashView> {
    
    var viewModel: SplashInterface

    init(viewModel: SplashInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        
        layoutView.backgroundColor = .gray30
    }
    
    override func bind() {
        
        // inputs
        viewModel.input.checkSignedIn.accept(())
        
        // outputs
        viewModel.output.isAutoSignIn
            .drive(with: self) { owner, isSuccess in
                
                guard let windowScene = UIApplication.shared.connectedScenes.first else { return }
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                
                if isSuccess {
                    
                    let newRootVC = HomeViewController()
                    let naviVC = UINavigationController(rootViewController: newRootVC)
                    let tabVC = UITabBarController()
                    
                    tabVC.setViewControllers([naviVC], animated: true)
                    sceneDelegate.window?.rootViewController = tabVC
                } else {
                    
                    let keyChainRepository = KeyChainRepositoryImpl()
                    let userDefaultsRepository = UserDefaultsRepositoryImpl()
                    let useCase = SignInUseCase(keyChainRepository: keyChainRepository,
                                                userDefaultsRepository: userDefaultsRepository)
                    let viewModel = SignInViewModel(signInUseCase: useCase)
                    let newRootVC = SignInViewController(viewModel: viewModel)
                    
                    let naviVC = UINavigationController(rootViewController: newRootVC)
                    sceneDelegate.window?.rootViewController = naviVC
                }
                
                sceneDelegate.window?.makeKeyAndVisible()
                
            }.disposed(by: disposeBag)
    }
}
