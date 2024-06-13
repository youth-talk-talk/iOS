//
//  SignInViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController<SignInView> {
    
    var viewModel: any ViewModelInterface
    
    let disposeBag = DisposeBag()
    
    init(viewModel: any ViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        guard let signInViewModel = viewModel as? SignInViewModel else { return }
        
        let input = signInViewModel.input
        
        // apple 로그인 버튼 클릭 이벤트 전달
        layoutView.appleSignInButton.rx.tap
            .bind(with: self) { owner, event in
                input.appleSignIn.accept(event)
            }.disposed(by: disposeBag)
        
        // Output
        let output = signInViewModel.transform(input: input)
        
        // apple 로그인 처리
        output.signInForApple
            .drive(with: self) { owner, _ in
                print("asdf")
            }.disposed(by: disposeBag)
    }
}
