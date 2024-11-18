//
//  NewPostViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import UIKit

class NewPostViewController: BaseViewController<NewPostView> {
    private lazy var addPhotoView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [selectPhotoInAlbumLabel, buttonCenterLineView, moveToCameraLabel]).then {
        $0.axis = .vertical
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = FontColor.gray30.value.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
    }
    
    private lazy var selectPhotoInAlbumLabel = UILabel().then {
        $0.text = "앨범에서 선택"
        $0.font = FontManager.font(.p16Regular16)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private lazy var buttonCenterLineView = UIView().then {
        $0.backgroundColor = FontColor.gray30.value
    }
    
    private lazy var moveToCameraLabel = UILabel().then {
        $0.text = "카메라로 이동"
        $0.font = FontManager.font(.p16Regular16)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private lazy var cancelLabel = UILabel().then {
        $0.text = "취소"
        $0.font = FontManager.font(.p16Regular16)
        $0.layer.borderColor = FontColor.gray30.value.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        // MARK: 정책명 검색 탭
        layoutView.policySearchButton.titleLabel.onTapped {
            
        }
        
        // MARK: 사진 추가 탭
        layoutView.addImageButton.onTapped { [weak self] in
            self?.addPhotoView.isHidden = false
        }
        
        cancelLabel.onTapped { [weak self] in
            self?.addPhotoView.isHidden = true
        }
        
        view.addSubview(addPhotoView)
        addPhotoView.addSubview(buttonStackView)
        addPhotoView.addSubview(cancelLabel)
        
        addPhotoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectPhotoInAlbumLabel.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        buttonCenterLineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        moveToCameraLabel.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.bottom.equalTo(cancelLabel.snp.top).offset(-8)
        }
        
        cancelLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(37)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(50)
        }
        
    }
    
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
