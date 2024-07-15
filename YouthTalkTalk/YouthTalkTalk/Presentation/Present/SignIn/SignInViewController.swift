//
//  SignInViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController<SignInView> {
    
    var viewModel: SignInInterface
    
    init(viewModel: SignInInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind() {
        
        // Inputs
        // apple 로그인 버튼 클릭 이벤트 전달
        layoutView.appleSignInButton.rx.tap
            .bind(to: viewModel.input.appleSignInButtonClicked)
            .disposed(by: disposeBag)
        
        // kakao 로그인 버튼 클릭 이벤트 전달
        layoutView.kakaoSignInButton.rx.tap
            .bind(to: viewModel.input.kakaoSignInButtonClicked)
            .disposed(by: disposeBag)
        
        // Outputs
        // apple 로그인 성공
        viewModel.output.signInSuccessApple
            .drive(with: self) { owner, isSuccess in
                
                owner.changeViewController(isSuccessToSignIn: isSuccess)
                
            }.disposed(by: disposeBag)
        
        // apple 로그인 실패
        viewModel.output.signInSuccessKakao
            .drive(with: self) { owner, isSuccess in
                
                owner.changeViewController(isSuccessToSignIn: isSuccess)
                
            }.disposed(by: disposeBag)
    }
    
    private func changeViewController(isSuccessToSignIn: Bool) {
        
        if isSuccessToSignIn {
            
            guard let windowScene = UIApplication.shared.connectedScenes.first else { return }
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            let repository = PolicyRepositoryImpl()
            let policyUseCase = PolicyUseCaseImpl(policyRepository: repository)
            let viewModel = HomeViewModel(policyUseCase: policyUseCase)
            let newRootVC = HomeViewController(viewModel: viewModel)
            let naviVC = UINavigationController(rootViewController: newRootVC)
            let tabVC = UITabBarController()
            
            tabVC.setViewControllers([naviVC], animated: true)
            sceneDelegate.window?.rootViewController = tabVC
            sceneDelegate.window?.makeKeyAndVisible()
        } else {
            let nextVC = TermsViewController()
            
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
