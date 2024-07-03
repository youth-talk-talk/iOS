//
//  TermsViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/15/24.
//

import UIKit
import RxCocoa

final class TermsViewController: BaseViewController<TermsView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationTitle(title: "약관동의")
    }
    
    override func bind() {
        
        layoutView.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                
                let policyLoactionUseCase = PolicyLocationUseCaseImpl()
                let signUpViewModel = SignUpViewModel(policyLocationUseCase: policyLoactionUseCase)
                let nextVC = SignUpViewController(viewModel: signUpViewModel)
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }.disposed(by: disposeBag)
        
        layoutView.cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
