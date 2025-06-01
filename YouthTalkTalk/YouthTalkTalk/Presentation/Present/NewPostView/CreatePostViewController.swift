//
//  NewPostViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import UIKit
import BSImagePicker
import Photos
import AVFoundation
import Combine

protocol UpdateEditedPostProtocol: AnyObject {
    func updateEditedPost(body: UploadPostBody)
}

final class CreatePostViewController: RootViewController {
    
    let postType: MainContentsType
    let writeType: WriteType
    let postData: RPEntity?
    
    weak var editDelegate: UpdateEditedPostProtocol?
    weak var delegate: EventDelegate?
    
    private lazy var cancelBag = Set<AnyCancellable>()
    
    private lazy var viewModel = ResultPolicyViewModel(type: PolicyCategory.allCases,
                                                       policyUseCase: PolicyUseCaseImpl(policyRepository: PolicyRepositoryImpl()))
    
    private var imagePickerController: ImagePickerProtocol?
   
    private let pageTitleLabel = UILabel().then {
        $0.designed(text: "후기 글쓰기", font: .p18Semi)
    }
    
    private lazy var selectedPolicyLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.designed(text: "정책 선택", font: .p16Regular16)
    }
    
    private lazy var searchIconImageView = UIImageView(image: .search)

    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private lazy var titleTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "제목을 입력해주세요.", textColor: .gray80, font: .p16Regular16)
        $0.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
    }
    
    private let dividerView2 = UIView().then {
        $0.backgroundColor = .gray30
    }
        
    private lazy var selectedPolicyId: Int = 0
    
    private lazy var contentContainerView = UIView()
    private lazy var contentScrollView = UIScrollView()
    private lazy var contentStackView = UIStackView(arrangedSubviews: [contentsTextView]).then {
        $0.axis = .vertical
        $0.spacing = 11
    }
    
    private let textViewPlaceHolder = "*후기로 무얼 적어야 할 지 모르겠다면 아래 질문에 대한 답을 적어주세요! \n부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다.\n\n ∙  해당 프로그램을 경험하면서 느낀 장점이나 단점이 있나요?\n ∙  주관부서에 남기고 싶은 피드백을 적어주세요!\n ∙  다음년도에 해당 프로그램을 신청할 청년들을 위한 tip!"
    
    private lazy var contentsTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = FontColor.gray80.value
        $0.font = FontManager.font(.p12Regular)
        $0.delegate = self
        $0.text = textViewPlaceHolder
        $0.isScrollEnabled = false
    }
    
    private let dividerView3 = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private lazy var writePostLabel = UILabel().then {
        $0.designed(text: "등록", font: .p12Regular, textColor: .gray70)
    }
    
    private lazy var addPhotoImageView = UIImageView(image: .addPhoto)
    
    private lazy var cameraVC = UIImagePickerController().then {
        $0.delegate = self
    }
    
    private lazy var searchPolicyView = SearchPolicyView(onPolicyTapped: { [weak self] selectedPolicy in
        self?.selectedPolicyLabel.text = selectedPolicy.policyTitle
        self?.selectedPolicyLabel.textColor = .black
        self?.selectedPolicyId = selectedPolicy.id
        
        self?.checkUploadButtonValid()
    })
    
    private lazy var addPhotoView = AddPhotoView()
    
    init(postType: MainContentsType, writeType: WriteType = .new, postData: RPEntity? = nil) {
        self.postType = postType
        self.writeType = writeType
        self.postData = postData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        imagePickerController = ImagePicker(presentationController: self,
                                            delegate: self,
                                            width: nil)
        
        layout()
        setTabEvents()
                
        // MARK: 게시글을 수정하는 경우 이전에 작성한 글 화면에 표시
        if writeType == .edit {
            titleTextField.text = postData?.title
            contentsTextView.text = postData?.content
            selectedPolicyLabel.text = postData?.policyTitle
            selectedPolicyId = Int(postData?.policyId ?? "") ?? 0
            contentsTextView.textColor = .black
        }
        
        // MARK: 게시글 작성 API 호출 성공
        viewModel.successUploadPost.sink { [weak self] item in
            self?.navigationController?.popViewController(animated: true)
            self?.delegate?.eventDelegate(item: item)
        }.store(in: &cancelBag)
        
        // MARK: 게시글 수정 API 성공
        viewModel.output.successEditPost.sink { [weak self] body in
            self?.editDelegate?.updateEditedPost(body: body)
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancelBag)
        
        addPhotoView.moveToCameraLabel.onTapped { [weak self] in
            AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
                guard isAuthorized else {
                    self?.showAlertGoToSetting()
                    
                    return
                }
                
                DispatchQueue.main.async {
                    let pickerController = UIImagePickerController()
                    pickerController.sourceType = .camera
                    pickerController.allowsEditing = false
                    pickerController.mediaTypes = ["public.image"]
                    pickerController.delegate = self
                    self?.present(pickerController, animated: true)
                }
            }
        }
    }
    
    private func setTabEvents() {
        selectedPolicyLabel.onTapped { [weak self] in
            self?.searchPolicyView.isHidden = false
        }
        
        addPhotoImageView.onTapped { [weak self] in
            self?.addPhotoView.isHidden = false
        }
        
        addPhotoView.cancelLabel.onTapped { [weak self] in
            self?.addPhotoView.isHidden = true
        }
        
        addPhotoView.selectPhotoInAlbumLabel.onTapped { [weak self] in
            self?.checkPermission()
        }
        
        writePostLabel.onTapped { [weak self] in
            guard let self else { return }
            
            if isUploadValid() {
                let images: [PostImageView] = Array(contentStackView.arrangedSubviews.dropFirst()) as? [PostImageView] ?? []
                
                viewModel.uploadImages(images.map{ $0.imageView.image?.pngData() }, body: .init(title: titleTextField.text ?? "",
                                                                                                postType: postType.key,
                                                                                      policyId: "\(selectedPolicyId)",
                                                                                                contentList: [.init(content: contentsTextView.text ?? "", type: "TEXT")]), writeType, postId: postData?.postId ?? 0)
            } else {
//                showAlertView("모두 작성되어야\n게시글 등록이 가능합니다", okAction: { [weak self] in
//                    self?.alertView.isHidden = true
//                })
            }
        }
        
//        setBackButtonTapped { [weak self] in
//            self?.showAlertView("글쓰기를 중단하시겠습니까?\n작성중이던 글이 사라집니다", okAction: { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            })
//        }
    }
    
    private func isUploadValid() -> Bool {
        let commonCondition = titleTextField.isNotEmpty() && contentsTextView.text != textViewPlaceHolder && !contentsTextView.text.isEmpty
        let reviewPostCondition = selectedPolicyLabel.text != "정책명" && commonCondition
        let freePostCondition = commonCondition
        
        return (postType == .review) ? reviewPostCondition : freePostCondition
    }
    
    private func checkUploadButtonValid() {
        writePostLabel.textColor = isUploadValid() ? .lime60 : FontColor.gray20.value
    }
    
    private func showAlertGoToSetting() {
        showAlert(title: "현재 카메라 사용에 대한 접근 권한이 없습니다.", content: "권한을 확인해주세요!", onAction: {
            guard let settingURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingURL)
            else { return }
            UIApplication.shared.open(settingURL, options: [:])
        })
    }
    
    private func layout() {
        view.addSubview(pageTitleLabel)
        view.addSubview(selectedPolicyLabel)
        view.addSubview(searchIconImageView)
        view.addSubview(dividerView)
        view.addSubview(titleTextField)
        view.addSubview(dividerView2)
        view.addSubview(contentsTextView)
        view.addSubview(dividerView3)
        view.addSubview(addPhotoImageView)
        view.addSubview(writePostLabel)
        view.addSubview(addPhotoView)
        view.addSubview(searchPolicyView)
        
        pageTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        selectedPolicyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(32))
            $0.trailing.equalTo(searchIconImageView.snp.leading).offset(moderate(-10))
            $0.height.equalTo(moderate(46))
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(24))
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.centerY.equalTo(selectedPolicyLabel)
        }
        
        dividerView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(selectedPolicyLabel.snp.bottom)
            $0.height.equalTo(moderate(1))
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(16))
            $0.leading.equalTo(selectedPolicyLabel)
            $0.trailing.equalTo(searchIconImageView)
        }
        
        dividerView2.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(titleTextField.snp.bottom).offset(moderate(16))
            $0.height.equalTo(moderate(1))
        }
        
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(moderate(16))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalTo(dividerView3)
            $0.height.greaterThanOrEqualTo(300)
        }
        
        dividerView3.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(moderate(1))
            $0.bottom.equalTo(addPhotoImageView.snp.top).offset(moderate(-14))
        }
        
        addPhotoImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(28))
            $0.bottom.equalToSuperview().inset(moderate(44))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        writePostLabel.snp.makeConstraints {
            $0.centerY.equalTo(pageTitleLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        addPhotoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchPolicyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,
                                 ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?) {
        if assets != nil {
            
            contentStackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
                contentStackView.removeArrangedSubview(view)
            }
            
            contentStackView.addArrangedSubview(contentsTextView)
            
            assets?.forEach({ asset in
                createImageContent(getAssetThumbnail(asset: asset))
            })
        }
        
        addPhotoView.isHidden = true
    }
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 641, height: 415), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    private func createImageContent(_ image: UIImage) {
        let imageView = PostImageView(image: image)
        
        imageView.deleteBackView.onTapped { [weak self] in
            imageView.removeFromSuperview()
            self?.contentStackView.removeArrangedSubview(imageView)
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(215)
            $0.width.equalTo(341)
        }
        
        contentStackView.addArrangedSubview(imageView)
    }
    
    private func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .limited:
            let actionSheet = UIAlertController(title: "",
                                                message: "더 많은 사진을 선택하거나 모든 사진에 대한 액세스를 허용하려면 설정으로 이동해주세요.",
                                                preferredStyle: .actionSheet)
            
            let selectPhotosAction = UIAlertAction(title: "더 많은 사진 선택",
                                                   style: .default) { [weak self] _ in
                guard let self = self else { return }
                if #available(iOS 15, *) {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { [weak self] _ in
                        self?.imagePickerController?.present()
                    }
                } else {
                    imagePickerController?.present()
                }
            }
            actionSheet.addAction(selectPhotosAction)
            
            let allowFullAccessAction = UIAlertAction(title: "권한 설정으로 이동",
                                                      style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(settingsURL) else { return }
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
            actionSheet.addAction(allowFullAccessAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
                self?.imagePickerController?.present()
            }
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
            
        case .authorized:
            imagePickerController?.present()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { [weak self] newStatus in
                guard let selfRef = self else { return }
                if newStatus == PHAuthorizationStatus.authorized {
                    selfRef.imagePickerController?.present()
                }
            }
        default:
            let alertView = TwoButtonAlertView(title: "사진을 불러올 수 없습니다. \n사진 접근 권한을 허용해주세요.") {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(settingsURL) else { return }
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
            
            view.addSubview(alertView)
            
            alertView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}

extension CreatePostViewController: UITextViewDelegate {
    @objc func titleTextFieldDidChange() {
        checkUploadButtonValid()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkUploadButtonValid()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = FontColor.gray80.value
        }
    }
}

extension CreatePostViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        createImageContent(image)
        
        picker.dismiss(animated: true, completion: nil)
        
        addPhotoView.isHidden = true
    }
}
