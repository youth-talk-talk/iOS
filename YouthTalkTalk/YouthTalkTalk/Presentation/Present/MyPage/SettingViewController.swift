//
//  SettingViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 6/1/25.
//

import UIKit

final class SettingViewController: RootViewController {
    
    private lazy var alarmLabel = UILabel().then {
        $0.designed(text: "앱 알림", font: .p16Regular16)
    }
    
    private lazy var alarmToggleView = UISwitch()
    
    private lazy var versionTitleLabel = UILabel().then {
        $0.designed(text: "앱 버전", font: .p16Regular16)
    }
    
    private lazy var versionLabel = UILabel().then {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            $0.designed(text: version + "(" + build + ")", font: .p16Regular16, textColor: .gray90)
        }
    }
    
    private lazy var exitLabel = UILabel().then {
        $0.designed(text: "회원탈퇴", font: .p16Regular16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuTitle("기타 관리")
        
        exitLabel.onTapped { [weak self] in
            self?.showAlert(title: "회원탈퇴",
                            content: "회원탈퇴 하시겠습니까?\n회원탈퇴 시 모든 정보는 즉시 삭제되며, 복구가 불가합니다.",
                            cancelText: "닫기",
                            actionText: "회원탈퇴",
                            actionColor: .subRed,
                            onAction: {
                    Task {
                        let result = await APIManager().requestAPI(
                            router: MeRouter.deleteAccount,
                            type: DeleteAccountDTO.self)
                        switch result {
                        case .success:
                            self?.goLoginPage()
                            
                        case .failure:
                            break
                        }
                    }
            })
        }
        
        view.addSubview(alarmLabel)
        view.addSubview(alarmToggleView)
        view.addSubview(versionTitleLabel)
        view.addSubview(versionLabel)
        view.addSubview(exitLabel)
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalTo(backImageView)
        }
        
        alarmToggleView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.centerY.equalTo(alarmLabel)
        }
        
        versionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(moderate(24))
            $0.leading.equalTo(alarmLabel)
        }
        
        versionLabel.snp.makeConstraints {
            $0.trailing.equalTo(alarmToggleView)
            $0.centerY.equalTo(versionTitleLabel)
        }
        
        exitLabel.snp.makeConstraints {
            $0.top.equalTo(versionTitleLabel.snp.bottom).offset(moderate(24))
            $0.leading.equalTo(versionTitleLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
    }
}
