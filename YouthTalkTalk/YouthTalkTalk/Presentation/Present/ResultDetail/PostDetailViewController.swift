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

class PostDetailViewController: BaseViewController<PostDetailView>, UITextFieldDelegate {
    // TODO: 게시글 생성, 삭제 기능 추가
    private lazy var moreImageView = UIImageView(image: UIImage(named: "more"))
    private lazy var keyboardHeight: CGFloat = 0
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardHideShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        layoutView.commentTextFieldView.textField.delegate = self
        
        // MARK: 댓글 작성 성공 시 호출
        viewModel.output.successUploadComment.sink { [weak self] in
            guard let self else { return }
            
            let commentView = CommentView(userName: viewModel.output.userNickName,
                                          comment: viewModel.output.writtenCommentText,
                                          isItOwnComment: true)
            layoutView.commentTextFieldView.textField.resignFirstResponder()
            layoutView.commentTextFieldView.textField.text = ""
            layoutView.commentStackView.addArrangedSubview(commentView)
            layoutView.commentCountLabel.text = "\(layoutView.commentStackView.arrangedSubviews.count)"
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
                    owner.layoutView.comment(data: comments, userNickName: viewModel.output.userNickName)
                }
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func bind() { }
    
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance: CGFloat = -keyboardHeight + view.safeAreaInsets.bottom
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up {
            movement = movementDistance
        } else {
            movement = -movementDistance
        }
        
        UIView.animate(withDuration: movementDuration, delay: 0, options: [.beginFromCurrentState]) {
            self.layoutView.commentTextFieldView.frame = self.layoutView.commentTextFieldView.frame.offsetBy(dx: 0, dy: movement)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            animateTextField(textField: layoutView.commentTextFieldView.textField, up: true)

        }
    }    
    
    @objc func keyboardHideShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            animateTextField(textField: layoutView.commentTextFieldView.textField, up: false)

        }
    }
}
