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
        
        // Outputs
        // apple 로그인 처리
        viewModel.output.signInForApple
            .drive(with: self) { owner, controller in
                
                let nextVC = TermsViewController()
                
                owner.navigationController?.pushViewController(nextVC, animated: true)
                
            }.disposed(by: disposeBag)
    }
}
