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
    private lazy var moreImageView = UIImageView(image: UIImage(named: "more"))
    private lazy var keyboardHeight: CGFloat = 0
    private lazy var moreContainerStackView = UIStackView(arrangedSubviews: [moreEditLabel,
                                                                             moreCenterLineView,
                                                                             moreDeleteLabel]).then {
        $0.axis = .vertical
        $0.backgroundColor = .white
        $0.distribution = .fillProportionally
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
    
    private lazy var isCommentChanging: Bool = false
    private lazy var idOfChangingComment: Int = 0
    
    private lazy var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: ResultDetailInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setTabEvents()
        
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
        
        view.addSubview(moreContainerStackView)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: moreImageView), animated: true)
        
        moreCenterLineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        moreContainerStackView.snp.makeConstraints {
            $0.top.equalTo(layoutView.nicknameLabel)
            $0.trailing.equalToSuperview().inset(17)
            $0.width.equalTo(121)
            $0.height.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func bind() {
        // MARK: 댓글 작성 성공 시 호출
        viewModel.output.successUploadComment.sink { [weak self] commentId in
            guard let self else { return }
            
            let commentView = CommentView(userName: viewModel.output.userNickName,
                                          commentId: commentId,
                                          comment: viewModel.output.writtenCommentText,
                                          isItOwnComment: true,
                                          isLiked: false)
            // MARK: 댓글 삭제 버튼
            commentView.deleteLabel.onTapped { [weak self] in
                self?.viewModel.input.commentDelete(commentId)
            }
            
            layoutView.commentTextFieldView.textField.resignFirstResponder()
            layoutView.commentTextFieldView.textField.text = ""
            layoutView.commentStackView.addArrangedSubview(commentView)
            layoutView.commentCountLabel.text = "\(layoutView.commentStackView.arrangedSubviews.count)"
        }
        .store(in: &cancelBag)
        
        // MARK: 초기 댓글 데이터 바인딩
        Observable.zip(viewModel.output.detailInfo, viewModel.output.commentsInfo)
            .bind(with: self) { owner, combined in
                
                let (detailRPEntity, comments) = combined
                
                owner.layoutView.configure(data: detailRPEntity) {
                    owner.layoutView.commentCountLabel.text = "\(comments.count)"
                    
                    comments.forEach { comment in
                        let isItOwnComment = (comment.nickname == owner.viewModel.output.userNickName)
                        let commentView = CommentView(userName: comment.nickname,
                                                      commentId: comment.commentId,
                                                      comment: comment.content,
                                                      isItOwnComment: isItOwnComment,
                                                      isLiked: comment.isLikedByMember)
                        
                        // MARK: 댓글 삭제 버튼
                        commentView.deleteLabel.onTapped { [weak self] in
                            self?.viewModel.input.commentDelete(comment.commentId)
                        }
                        
                        // MARK: 댓글 수정 버튼
                        commentView.editLabel.onTapped { [weak self] in
                            self?.isCommentChanging = true
                            self?.layoutView.commentTextFieldView.textField.becomeFirstResponder()
                            self?.layoutView.commentTextFieldView.textField.text = comment.content
                            self?.idOfChangingComment = comment.commentId
                        }
                        
                        // MARK: 댓글 좋아요 버튼
                        commentView.likeImageView.onTapped { [weak self] in
                            self?.viewModel.input.likeComment(comment.commentId, !commentView.isLiked)
                        }
                        
                        owner.layoutView.commentStackView.addArrangedSubview(commentView)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: 댓글 삭제 API 완료
        viewModel.output.successDeleteComment.sink { [weak self] deletedCommentId in
            guard let commentViews = self?.layoutView.commentStackView.arrangedSubviews as? [CommentView],
                  let deletedCommentView = commentViews.first(where: { $0.commentId == deletedCommentId }) else { return }
            
            deletedCommentView.removeFromSuperview()
            self?.layoutView.commentStackView.removeArrangedSubview(deletedCommentView)
            
        }.store(in: &cancelBag)
        
        // MARK: 댓글 수정 API 완료
        viewModel.output.successEditComment.sink { [weak self] (commentId, commentContent) in
            self?.isCommentChanging = false

            guard let commentViews = self?.layoutView.commentStackView.arrangedSubviews as? [CommentView],
                  let editedCommentView = commentViews.first(where: { $0.commentId == commentId }) else { return }
            
            self?.layoutView.commentTextFieldView.textField.resignFirstResponder()
            self?.layoutView.commentTextFieldView.textField.text = ""
            
            editedCommentView.commentLabel.text = commentContent
            
        }.store(in: &cancelBag)
        
        // MARK: 댓글 좋아요 API 완료
        viewModel.output.successLikeComment.sink { [weak self] (commentId, isLiked) in
            guard let commentViews = self?.layoutView.commentStackView.arrangedSubviews as? [CommentView],
                  let likedCommentView = commentViews.first(where: { $0.commentId == commentId }) else { return }
            
            likedCommentView.isLiked = !likedCommentView.isLiked
            likedCommentView.likeImageView.image = isLiked ? UIImage(named: "like_fill") : UIImage(named: "like")
            
        }.store(in: &cancelBag)
        
        // MARK: 게시글 삭제 API 완료
        viewModel.output.successDeletePost.sink { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancelBag)
    }
    
    private func setTabEvents() {
        // MARK: 댓글 작성 버튼 탭
        layoutView.commentTextFieldView.commentTap.rx.event
            .bind(with: self) { [weak self] owner, _ in
                guard let self, let text = layoutView.commentTextFieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if text != "", let postId = owner.viewModel.output.rpEntity.postId {
                    
                    if isCommentChanging { // MARK: 댓글 수정
                        owner.viewModel.output.editComment(commentId: idOfChangingComment,
                                                           newComment: text)
                    } else { // MARK: 댓글 작성
                        owner.viewModel.output.uploadPostComment(.init(postId: postId,
                                                                       content: text))
                    }
                }
            }
            .disposed(by: disposeBag)
        
        moreImageView.onTapped { [weak self] in
            self?.moreContainerStackView.isHidden.toggle()
        }
        
        // MARK: 게시글 수정 버튼 탭
        moreEditLabel.onTapped { [weak self] in
            
        }
        
        // MARK: 게시글 삭제 버튼 탭
        moreDeleteLabel.onTapped { [weak self] in
            self?.showAlertView("게시물을 삭제하시겠습니까?",
                                okAction: { [weak self] in
                self?.viewModel.input.deletePost.accept(())
            })
        }
    }
    
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
