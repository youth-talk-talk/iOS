//
//  ResultDetailViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class ResultDetailViewController: BaseViewController<ResultDetailView> {
    
    private let viewModel: ResultDetailInterface
    
    init(viewModel: ResultDetailInterface) {
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
        
        // 입력 버튼 클릭
        layoutView.commentTextFieldView.commentTap.rx.event
            .bind(with: self) { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
        viewModel.output.detailInfo
            .bind(with: self) { owner, detailRPEntity in
                
                owner.layoutView.configure(data: detailRPEntity)
            }
            .disposed(by: disposeBag)
    }
}
