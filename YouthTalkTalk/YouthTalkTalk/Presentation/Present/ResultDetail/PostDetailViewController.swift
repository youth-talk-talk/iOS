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
import Combine

class PostDetailViewController: BaseViewController<PostDetailView> {
    // TODO: 게시글 생성, 삭제 기능 추가
    private lazy var moreImageView = UIImageView(image: UIImage(named: "more"))
    
    private lazy var moreContainerStackView = UIStackView(arrangedSubviews: [moreEditLabel,
                                                                             moreCenterLineView,
                                                                             moreDeleteLabel]).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = FontColor.gray30.value.cgColor
        $0.layer.borderWidth = 1
        $0.isHidden = true
    }
    
    private lazy var moreEditLabel = UILabel().then {
        $0.designed(text: "수정", fontType: .p16Regular16)
        $0.textAlignment = .center
    }
    
    private lazy var moreCenterLineView = UIView().then {
        $0.backgroundColor = FontColor.gray30.value
    }
        
    private lazy var moreDeleteLabel = UILabel().then {
        $0.designed(text: "삭제", fontType: .p16Regular16)
        $0.textAlignment = .center
    }
    
    private let viewModel: ResultDetailInterface
    
    private lazy var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: ResultDetailInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.output.successUploadComment.sink { [weak self] in
            // TODO: 이부분 내 정보 데이터에서 이름 가져와서 넣기
            let commentView = CommentView(userName: "", // viewModel.output.commentWriterName,
                                          comment: viewModel.output.writtenCommentText)
            
            self?.layoutView.commentStackView.addArrangedSubview(commentView)
        }
        .store(in: &cancelBag)
        
        layoutView.commentTextFieldView.commentTap.rx.event
            .bind(with: self) { [weak self] owner, _ in
                guard let text = self?.layoutView.commentTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if text != "", let postId = viewModel.output.rpEntity.postId {
                    viewModel.output.uploadPostComment(.init(postId: postId,
                                                             content: text))
                }
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() { }
}
