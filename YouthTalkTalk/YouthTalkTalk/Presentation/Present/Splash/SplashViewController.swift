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
        
        // outputs
        viewModel.output.isAutoSignIn
            .drive(with: self) { owner, isSuccess in
                
                if isSuccess {
                    owner.navigateToHome()
                } else {
                    owner.navigateToSignIn()
                }
            }
            .disposed(by: disposeBag)
        
        // inputs
        viewModel.input.checkSignedIn.accept(())
    }
    
    private func navigateToHome() {
        
        SceneDelegate.makeRootVC()
    }
    
    private func navigateToSignIn() {
        let useCase = SignInUseCaseImpl()
        let viewModel = SignInViewModel(signInUseCase: useCase)
        let newRootVC = SignInViewController(viewModel: viewModel)
        let naviVC = UINavigationController(rootViewController: newRootVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                fatalError("Failed to get SceneDelegate")
            }
            sceneDelegate.window?.rootViewController = naviVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
