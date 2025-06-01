//
//  EditMyInfoViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/6/25.
//

import UIKit
import BSImagePicker
import Photos
import RxSwift
import AVFoundation
import Kingfisher

final class EditMyInfoViewController: RootViewController {
    
    private let viewModel: MyPageViewModel
    private var disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.designed(text: "내 계정", font: .p18Semi)
    }
    
    private let saveLabel = UILabel().then {
        $0.designed(text: "저장", font: .p12Regular, textColor: .green)
    }
    
    private let profileImageView = UIImageView(image: .profileLogo).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = moderate(47)
        $0.clipsToBounds = true
    }
    
    private let photoImageView = UIImageView(image: .camera)
    
    private let nameLabel = UILabel().then {
        $0.designed(text: "닉네임", font: .p14Regular, textColor: .gray90)
    }
    
    private let nameView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let nameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요."
        $0.font = FontManager.font(.p16Regular16)
    }
    
    private let regionLabel = UILabel().then {
        $0.designed(text: "관심 지역", font: .p14Regular, textColor: .gray90)
    }
    
    private let regionView = UIView().then {
        $0.layer.cornerRadius = moderate(6)
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let regionSelectLabel = UILabel().then {
        $0.designed(text: "지역을 선택해 주세요.", font: .p16Regular16)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray40
    }
    
    private let logoutLabel = UILabel().then {
        $0.designed(text: "로그아웃", font: .p14Regular, textColor: .gray70)
    }
    
    private let regionArrowImageView = UIImageView().then {
        $0.image = .arrowDown
    }
    
    private var imagePickerController: ImagePickerProtocol?
    
    private var profileImageData: Data?
    
    init(_ myInfo: MeDTO, _ viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        if let url = URL(string: myInfo.data.profileImgUrl ?? "") {
            profileImageView.kf.setImage(with: url)
        }
        
        nameTextField.text = myInfo.data.nickname
        regionSelectLabel.text = myInfo.data.region
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController = ImagePicker(presentationController: self,
                                            delegate: self,
                                            width: nil)
        
        logoutLabel.onTapped { [weak self] in
            self?.goLoginPage()
        }
        
        backImageView.onTapped { [weak self] in
            self?.showAlert(title: "프로필 편집 나가기",
                            content: "화면을 나가면 변경사항이 저장되지 않습니다.\n나가시겠습니까?",
                            cancelText: "나가기",
                            actionText: "편집하기",
                            onCancel: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        saveLabel.onTapped { [weak self] in
            self?.showAlert(title: "프로필 저장",
                            content: "변경된 내용을 저장하시겠습니까?",
                            cancelText: "닫기",
                            actionText: "저장하기",
                            onAction: { [weak self] in
                
                if let image = self?.profileImageData {
                    // 새로 등록한 이미지가 있다면 이미지 등록 API 호출
                    APIManager().postUploadImage(stringURL: "/members/profile", image: image)
                        .subscribe({ [weak self] result in
                            guard let self else { return }
                            
                            switch result {
                            case.success(let data):
                                switch data {
                                case .success(let url):
                                    viewModel.editMyInfo(nickname: nameTextField.text,
                                                         region: regionSelectLabel.text ?? "서울",
                                                         onSuccess: { [weak self] in
                                        DispatchQueue.main.async {
                                            self?.navigationController?.popViewController(animated: true)
                                        }
                                    })
                                case .failure:
                                    break
                                }
                                
                            case .failure:
                                break
                            }
                        })
                        .disposed(by: self?.disposeBag ?? .init())
                    
                } else {
                    // 이미지가 없으면 바로 내 정보 수정 API 호출
                    self?.viewModel.editMyInfo(nickname: self?.nameTextField.text,
                                               region: self?.regionSelectLabel.text ?? "서울",
                                               onSuccess: { [weak self] in
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            })
        }
        
        profileImageView.onTapped { [weak self] in
            self?.checkPermission()
        }
        
        regionArrowImageView.onTapped { [weak self] in
            guard let self else { return }
            
            let vc = RegionBottomSheetViewController(selectedRegion: regionSelectLabel.text,
                                                     onRegionTapped: { [weak self] selectedRegion in
                self?.regionSelectLabel.text = selectedRegion?.networkName
            })
            
            if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
            
            present(vc, animated: true, completion: nil)
        }
        
        view.addSubviews(titleLabel,
                         saveLabel,
                         profileImageView,
                         photoImageView,
                         nameLabel,
                         nameView,
                         regionLabel,
                         regionView,
                         dividerView,
                         logoutLabel)
        
        nameView.addSubview(nameTextField)
        
        regionView.addSubview(regionSelectLabel)
        regionView.addSubview(regionArrowImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.centerX.equalToSuperview()
        }
        
        saveLabel.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(29))
            $0.size.equalTo(moderate(94))
        }
        
        photoImageView.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView)
            $0.size.equalTo(moderate(20))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        nameView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(nameLabel.snp.bottom).offset(moderate(12))
        }
        
        nameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameView)
            $0.top.equalTo(nameView.snp.bottom).offset(moderate(20))
        }
        
        regionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(46))
            $0.top.equalTo(regionLabel.snp.bottom).offset(moderate(12))
        }
        
        regionSelectLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(12))
            $0.trailing.equalTo(regionArrowImageView.snp.leading)
        }
        
        regionArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(20))
            $0.trailing.equalToSuperview().inset(moderate(12))
            $0.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(1)
            $0.top.equalTo(regionView.snp.bottom).offset(moderate(30))
        }
        
        logoutLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(20))
        }
    }
}

extension EditMyInfoViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditMyInfoViewController: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,
                                 ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?) {
        if assets != nil, let firstImage = assets?.first {
            let uiimage = getAssetThumbnail(asset: firstImage)
            profileImageView.image = getAssetThumbnail(asset: firstImage)
            profileImageData = uiimage.pngData()
        }
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
