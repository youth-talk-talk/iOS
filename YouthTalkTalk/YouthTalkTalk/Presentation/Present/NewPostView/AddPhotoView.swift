//
//  AddPhotoView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/21/24.
//

import UIKit

final class AddPhotoView: UIView {
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [selectPhotoInAlbumLabel, buttonCenterLineView, moveToCameraLabel]).then {
        $0.axis = .vertical
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = FontColor.gray30.value.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
    }
    
    lazy var selectPhotoInAlbumLabel = UILabel().then {
        $0.text = "앨범에서 선택"
        $0.font = FontManager.font(.p16Regular16)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private lazy var buttonCenterLineView = UIView().then {
        $0.backgroundColor = FontColor.gray30.value
    }
    
    lazy var moveToCameraLabel = UILabel().then {
        $0.text = "카메라로 이동"
        $0.font = FontManager.font(.p16Regular16)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    lazy var cancelLabel = UILabel().then {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.5)
        isHidden = true
        
        addSubview(buttonStackView)
        addSubview(cancelLabel)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
