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

final class NewPostViewController: BaseViewController<NewPostView> {
    
    weak var delegate: EventDelegate?
    
    private lazy var cancelBag = Set<AnyCancellable>()
    
    private lazy var viewModel = ResultPolicyViewModel(type: PolicyCategory.allCases,
                                                       policyUseCase: PolicyUseCaseImpl(policyRepository: PolicyRepositoryImpl()))
    
    private var imagePickerController: ImagePickerProtocol?
    
    private lazy var titleLabel = UILabel().then {
        $0.designed(text: "제목", fontType: .p16SemiBold, textColor: .black)
    }
    
    private lazy var titleTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "제목을 작성해주세요", textColor: .gray50, font: .p16Regular16)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray20.value.cgColor
        $0.layer.cornerRadius = 8
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        $0.leftViewMode = .always
    }
    
    private lazy var policyView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray20.value.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private lazy var policyLabel = UILabel().then {
        $0.designed(text: "정책명", fontType: .p16SemiBold, textColor: .black)
    }
    
    private lazy var selectedPolicyLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.designed(text: "정책명", fontType: .p16Regular16, textColor: .gray50)
    }
    
    private lazy var selectedPolicyId: String = ""
    
    private lazy var searchIconImageView = UIImageView(image: UIImage(named: "magnifyingglass"))
    
    private lazy var contentsLabel = UILabel().then {
        $0.designed(text: "내용 작성", fontType: .p16SemiBold, textColor: .black)
    }
    
    private lazy var contentContainerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray20.value.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private lazy var contentScrollView = UIScrollView()
    
    private lazy var contentStackView = UIStackView(arrangedSubviews: [contentsTextView]).then {
        $0.axis = .vertical
        $0.spacing = 11
    }
    
    private let textViewPlaceHolder = "*후기로 무얼 적어야 할 지 모르겠다면 아래 질문에 대한 답을 적어주세요!\n 1. 해당프로그램을 경험하면서 느낀 장점이나 단점이 있나요?\n 2. 주관부서에 남기고 싶은 피드백을 적어주세요!\n 3. 다음년도에 해당 프로그램을 신청할 청년들을 위한 tip!"
    
    private lazy var contentsTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = FontColor.gray40.value
        $0.delegate = self
        $0.text = textViewPlaceHolder
        $0.isScrollEnabled = false
    }
    
    private lazy var addPhotoContainerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = FontColor.gray20.value.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private lazy var addPhotoStackView = UIStackView(arrangedSubviews: [addPhotoImageView, addPhotoLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private lazy var addPhotoImageView = UIImageView(image: UIImage(named: "addPhoto"))
    
    private lazy var addPhotoLabel = UILabel().then {
        $0.designed(text: "사진추가하기", fontType: .p16Regular16)
    }
    
    private lazy var cameraVC = UIImagePickerController()
    
    private lazy var writePostLabel = UILabel().then {
        $0.backgroundColor = FontColor.gray20.value
        $0.layer.cornerRadius = 25
        $0.designed(text: "등록하기", fontType: .p16Regular16)
        $0.textAlignment = .center
        $0.clipsToBounds = true
    }
    
    private lazy var searchPolicyView = SearchPolicyView(onPolicyTapped: { [weak self] selectedPolicy in
        self?.selectedPolicyLabel.text = selectedPolicy.policyTitle
        self?.selectedPolicyLabel.textColor = .black
        self?.selectedPolicyId = selectedPolicy.id
    })
    
    private lazy var addPhotoView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationTitle(title: "후기글쓰기")
        
        tabBarController?.tabBar.isHidden = true
        
        imagePickerController = ImagePicker(presentationController: self,
                                            delegate: self,
                                            width: nil)
        
        layout()
        setTabEvents()
        
        cameraVC.delegate = self
        
        // MARK: 게시글 작성 API 호출 성공
        viewModel.successUploadPost.sink { [weak self] item in
            self?.navigationController?.popViewController(animated: true)
            self?.delegate?.eventDelegate(item: item)
        }
        .store(in: &cancelBag)
        
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
        
        addPhotoContainerView.onTapped { [weak self] in
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
            
            if titleLabel.isNotEmpty() && selectedPolicyLabel.text != "정책명" && contentsTextView.text != textViewPlaceHolder {
                
                
                guard let images = Array(contentStackView.arrangedSubviews.dropFirst()) as? [PostImageView] else { return
                    print("|| \(contentStackView.arrangedSubviews.count), \(Array(contentStackView.arrangedSubviews.dropFirst()) as? [PostImageView])")
                }
                
                
                
                viewModel.uploadImages(images.map{ $0.imageView.image?.pngData() }, body: .init(title: titleTextField.text ?? "",
                                                                                      postType: "review",
                                                                                      policyId: "\(selectedPolicyId)",
                                                                                      contentList: [.init(content: contentsTextView.text ?? "", type: "TEXT")]))
            } else {
                showAlertView("모두 작성되어야\n게시글 등록이 가능합니다", okAction: { [weak self] in
                    self?.alertView.isHidden = true
                })
            }
        }
        
        setBackButtonTapped { [weak self] in
            self?.showAlertView("글쓰기를 중단하시겠습니까?\n작성중이던 글이 사라집니다", okAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private func showAlertGoToSetting() {
        showAlertView("현재 카메라 사용에 대한 접근 권한이 없습니다.") {
            guard let settingURL = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingURL)
            else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(policyLabel)
        view.addSubview(policyView)
        view.addSubview(contentsLabel)
        view.addSubview(contentContainerView)
        view.addSubview(addPhotoContainerView)
        view.addSubview(writePostLabel)
        addPhotoContainerView.addSubview(addPhotoStackView)
        contentScrollView.addSubview(contentStackView)

        contentContainerView.addSubview(contentScrollView)
        
        policyView.addSubview(selectedPolicyLabel)
        policyView.addSubview(searchIconImageView)
        
        view.addSubview(searchPolicyView)
        view.addSubview(addPhotoView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17)
            $0.top.equalToSuperview().inset(131)
        }
        
        titleTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(71)
            $0.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(50)
            $0.centerY.equalTo(titleLabel)
        }
        
        policyLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
        }
        
        policyView.snp.makeConstraints {
            $0.leading.trailing.height.equalTo(titleTextField)
            $0.centerY.equalTo(policyLabel)
        }
        
        selectedPolicyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.trailing.equalTo(searchIconImageView.snp.leading).offset(-17)
            $0.centerY.equalToSuperview()
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(policyLabel.snp.bottom).offset(38)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.top.equalTo(contentsLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addPhotoContainerView.snp.top).offset(-12)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        addPhotoContainerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentContainerView)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        addPhotoStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addPhotoImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        writePostLabel.snp.makeConstraints {
            $0.size.equalTo(addPhotoContainerView)
            $0.top.equalTo(addPhotoContainerView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(46)
            $0.centerX.equalToSuperview()
        }
        
        addPhotoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchPolicyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension NewPostViewController: UIImagePickerControllerDelegate,
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

extension NewPostViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = FontColor.gray40.value
        }
    }
}

extension NewPostViewController {
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
