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
    
    override func bind() {
        
        // 입력 버튼 클릭
        layoutView.commentTextFieldView.commentTap.rx.event
            .bind(with: self) { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
        Observable.zip(viewModel.output.detailInfo, viewModel.output.commentsInfo)
            .bind(with: self) { owner, combined in
                
                let (detailRPEntity, comments) = combined
                
                owner.layoutView.configure(data: detailRPEntity) {
                    owner.layoutView.comment(data: comments)
                }
            }
            .disposed(by: disposeBag)
    }
}
