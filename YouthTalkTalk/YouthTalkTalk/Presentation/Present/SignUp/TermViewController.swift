//
//  TermViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/22/25.
//

import UIKit

final class TermViewController: RootViewController {
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.designed(text: "반가워요!\n가입하려면 약관동의가 필요해요.", font: .p18Semi)
    }
    
    private let checkImageView = UIImageView(image: .check)
    
    private let termLabel = UILabel().then {
        $0.designed(text: "이용약관", font: .p14Regular, textColor: .gray80)
    }
    
    private let requiredLabel = UILabel().then {
        $0.designed(text: "필수", font: .p14Regular, textColor: .green)
    }
    
    private let arrowImageView = UIImageView(image: .arrowDown.withTintColor(.black))
    
    private let termContainerView = UIView().then {
        $0.backgroundColor = .gray20
        $0.layer.cornerRadius = 16
        $0.isHidden = true
    }
    
    private lazy var termTextView = UITextView().then {
        $0.isEditable = false
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.textColor = .gray90
        $0.font = FontManager.font(.p12Regular)
        $0.text = termText
    }
    
    private let nextButton = UIButton().then {
        $0.designed(title: "다음")
        $0.isEnabled = false
    }
    
    private var isChecked = false
    private var isTermVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkImageView.onTapped { [weak self] in
            guard let self else { return }
            
            isChecked.toggle()
            
            checkImageView.image = isChecked ? .checkBoxGreen : .check
            nextButton.isEnabled = isChecked
        }
        
        arrowImageView.onTapped { [weak self] in
            guard let self else { return }
            
            isTermVisible.toggle()
            termContainerView.isHidden = !isTermVisible
            arrowImageView.image = isTermVisible ? .arrowUpBlack : .arrowDown.withTintColor(.black)
        }
        
        nextButton.onTapped { [weak self] in
            let vc = WriteNickNameViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        view.addSubview(titleLabel)
        view.addSubview(checkImageView)
        view.addSubview(termLabel)
        view.addSubview(requiredLabel)
        view.addSubview(arrowImageView)
        view.addSubview(termContainerView)
        view.addSubview(nextButton)
        
        termContainerView.addSubview(termTextView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(20))
            $0.leading.equalToSuperview().inset(16)
        }
        
        checkImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalTo(titleLabel)
            $0.size.equalTo(20)
        }
        
        termLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkImageView)
            $0.leading.equalTo(checkImageView.snp.trailing).offset(8)
        }
        
        requiredLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkImageView)
            $0.leading.equalTo(termLabel.snp.trailing).offset(4)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(checkImageView)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        termContainerView.snp.makeConstraints {
            $0.top.equalTo(checkImageView.snp.bottom).offset(18)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(arrowImageView)
            $0.bottom.equalTo(nextButton.snp.top).offset(-128)
        }
        
        termTextView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(26)
        }
    }
    
    private let termText = """
    
제 1조 (목적)

이 약관은 청년톡톡(이하 ‘회사’)에서 제공하는 회사의 모든 서비스를 이용함에 있어 회사와 회원의 권리, 의무 및 책임사항을 규정합니다.


제2조 (용어의 정리)


이 약관에서 사용하는 주요한 용어의 정의는 다음과 같습니다.

회원: 회사의 약관을 승인하고 회사와 서비스 이용계약을 체결한 자를 말합니다.

서비스: 회사 사이트와 모바일 어플리케이션에서 제공하는 모든 무형의 서비스, 또는 판매 가능한 상품을 말합니다.

사진 데이터: 회원이 서비스를 이용하면서 서비스 상에서 사진을 등록하면서 기록한 모든 정보를 말합니다.

콘텐츠: 회사가 회원에게 제공하는 서비스상의 부가기능 기술을 포함한 모든 부호, 문자, 도형, 색채, 음성, 음향, 이미지, 사진 및 영상 등의 자료 또는 정보를 포함하되 이에 한정되지 아니합니다.

위 항에서 정의되지 않은 이 약관 상의 용어의 의미는 일반적인 관행에 의합니다.


제3조 (약관의 효력 및 변경)

회사는 약관의 내용에 대해 회원가입 단계에서 반드시 회원이 확인할 수 있도록 합니다.

이 약관은, 약관에 대해서 가입자가 동의하고 회사의 서비스에 회원가입을 한 순간부터 효력이 발생됩니다.

회사는 약관의 규제에 관한 법률(약관법), 정보통신망 이용 촉진 및 정보보호 등에 관한 법률 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.

회사는 약관의 내용을 변경할 시, 홈페이지 공지, 회원가입 시 공지 또는 전자우편 등의 기타 방법으로 공지합니다. 또한 적용일자 및 개정사유를 명시하여 현행 약관과 함께 사이트 또는 그 연결화면에 그 적용일자 전에 공지하고, 전자메일 등을 이용하여 통지합니다. 다만 회원에게 불리하게 약관 내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지 또는 통지합니다. 회원들이 언제든지 확인할 수 있도록 합니다.

기존 회원들은 회사가 변경된 약관의 수정사항을 홈페이지 공지, 전자우편 등의 방법을 통해 공지 및 통지를 하면서 적용일자 전까지 이의를 하지 아니하는 경우 동의한 것으로 간주된다는 뜻을 명확하게 공지 및 통지하였음에도 회원이 별도의 거부 의사표시를 하지 아니하였거나, 변경된 약관에 대해 동의한 것으로 간주합니다. 만약 회사의 변경된 약관에 대해서 동의하지 않는다면, 회원은 그 이용을 즉시 중단하거나 탈퇴함으로써 약관의 내용을 거부할 수 있고, 변경된 약관의 적용을 받는 해당 서비스의 제공이 더 이상 불가능하게 될 수 있습니다. 이는 회사가 약관 뿐 만 아니라, 각 개별 서비스의 고유한 특성을 반영하기 위해 마련한 이 약관 외에 결제서비스약관, 환불 규정 개인정보처리방침 등의 경우에도 동일하게 적용됩니다.


제 4조 (서비스 이용 계약)

회사는 회원의 서비스 가입 신청을 승낙함으로써 서비스 이용 계약이 체결됩니다.

회사는 다음 각 호에 해당하는 경우 회원가입을 승낙하지 않을 수 있습니다.

신청자가 만 14세 미만인 경우

타인의 명의를 도용하여 신청한 경우

서비스 이용 계약을 체결할 수 없는 사유가 발생한 경우

기타 회사의 정책상 회원가입을 허가할 수 없는 경우


제 5조 (회원의 의무)

회원은 서비스 이용과 관련하여 다음과 같은 의무를 집니다.

회원 가입 시 제공한 정보는 정확하고 최신의 정보를 유지해야 하며, 이를 위반하여 발생하는 모든 문제에 대해서는 회원이 책임을 집니다.

회원은 자신의 계정 정보를 보호하고, 제3자에게 이를 양도 또는 대여할 수 없습니다.

회원은 서비스를 이용함에 있어 관련 법령을 준수하고, 타인의 권리를 침해하거나 부당한 이익을 추구하는 행위를 해서는 안 됩니다.


제 6조 (서비스의 제공 및 변경)

회사는 서비스의 내용을 변경하거나 추가할 수 있으며, 그에 따른 별도의 통지를 회원에게 제공할 수 있습니다.

회사는 정기적인 유지보수, 보안 점검 등을 이유로 서비스의 일시적인 중단이 발생할 수 있습니다.

회사는 서비스에 발생할 수 있는 문제를 해결하기 위해 최대한 신속하게 노력합니다.


제 7조 (서비스의 이용)

회사는 서비스 이용에 있어 회원의 권리와 의무를 보장합니다.

서비스는 계약에 명시된 조건에 따라 제공되며, 회사는 회원이 계약을 체결한 대로 서비스가 제공되도록 할 의무가 있습니다.

회사는 서비스 이용에 있어 발생할 수 있는 기술적인 문제를 해결하기 위해 최선을 다하며, 문제 발생 시 조치하는 것을 원칙으로 합니다.


제 8조 (회원 탈퇴 및 자격 정지)

회원은 언제든지 탈퇴를 요청할 수 있으며, 탈퇴는 즉시 이루어집니다.

회사는 회원이 본 약관을 위반하거나 서비스의 이용 목적에 반하는 행위를 한 경우 회원 자격을 정지하거나 계약을 해지할 수 있습니다.

회사는 회원 탈퇴 시 회원의 개인정보를 삭제하며, 이는 법적 의무에 의해 보존이 필요한 경우를 제외하고는 즉시 처리됩니다.


제 9조 (개인정보의 보호)

회사는 개인정보보호법 등 관련 법령을 준수하여 회원의 개인정보를 보호합니다.

회사는 회원의 개인정보를 회원의 동의 없이 제3자에게 제공하지 않습니다. 다만, 법령에 의한 요청이나 회원의 동의가 있는 경우에는 예외로 합니다.


제 10조 (저작권)

회사가 제공하는 모든 콘텐츠에 대한 저작권은 회사에게 귀속됩니다.

회원은 서비스 내에서 제공되는 콘텐츠를 복제, 배포, 전시하거나 상업적 용도로 사용할 수 없습니다.


제 11조 (면책 조항)

회사는 천재지변, 전쟁, 불가항력적인 사건 등 예측할 수 없는 사유로 인해 서비스 제공에 어려움이 있을 경우, 서비스의 일시적 중단에 대해 책임지지 않습니다.

회사는 회원이 서비스 이용 중 발생한 손해에 대해 책임지지 않습니다. 다만, 회사의 고의 또는 중대한 과실로 인한 손해는 배상할 책임이 있습니다.


제 12조 (분쟁 해결)

회사와 회원 간의 분쟁이 발생한 경우, 양 당사자는 상호 협의하여 해결합니다.

협의가 이루어지지 않는 경우, 회사의 본사 소재지 관할 법원에서 소송을 제기할 수 있습니다.


제 13조 (기타)

회사는 서비스에 대한 운영 및 관리 방침을 변경할 수 있으며, 그에 대한 사항은 별도로 공지합니다.

본 약관은 2025년 4월 27일부터 시행됩니다.
"""
    
}


