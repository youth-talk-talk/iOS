//
//  AgeAndIncomeCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/3/25.
//

import UIKit
import SnapKit
import Then

final class AgeAndIncomeCategoryViewController: UIViewController {
    // MARK: - Properties
    private let annualIncomeLabel = UILabel().then {
        $0.font = FontManager.font(.p14SemiBold)
        $0.textColor = .gray100
        $0.text = "연소득"
    }
    
    private let slidedAnnualIncomeLabel = UILabel().then {
        $0.font = FontManager.font(.p14Medium)
        $0.textColor = .greenNormal
        $0.text = "0만원 이상"
    }
    
    private let annualIncomeSlider = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 5000
        $0.value = 0
        $0.minimumTrackTintColor = .greenNormal
        $0.maximumTrackTintColor = .gray70
        $0.thumbTintColor = .white
    }
    private let annualIncomeMinLabel = UILabel().then {
        $0.font = FontManager.font(.p12Medium)
        $0.textColor = .gray70
        $0.text = "0원"
    }
    private let annualIncomeMidLabel = UILabel().then {
        $0.font = FontManager.font(.p12Medium)
        $0.textColor = .gray70
        $0.text = "2500만원"
    }
    private let annualIncomeMaxLabel = UILabel().then {
        $0.font = FontManager.font(.p12Medium)
        $0.textColor = .gray70
        $0.text = "최대"
    }
    
    private let ageLabel = UILabel().then {
        $0.font = FontManager.font(.p14SemiBold)
        $0.textColor = .gray100
        $0.text = "연령"
    }
    private let agePrefixLabel = UILabel().then {
        $0.font = FontManager.font(.p14Medium)
        $0.textColor = .gray90
        $0.text = "만"
    }
    private let ageTextField = UITextField().then {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.font = FontManager.font(.p16Regular16)
        $0.textColor = .gray90
        $0.textAlignment = .right
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray50.cgColor
        $0.placeholder = "20"
    }
    
    private let ageSuffixLabel = UILabel().then {
        $0.font = FontManager.font(.p14Medium)
        $0.textColor = .gray90
        $0.text = "세"
    }
    
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - SetupUI
    private func setupLayout() {
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        // 연소득 행 (라벨 + 값)
        let incomeTitleRow = UIStackView(arrangedSubviews: [annualIncomeLabel, slidedAnnualIncomeLabel]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        verticalStackView.addArrangedSubview(incomeTitleRow)
        verticalStackView.addArrangedSubview(self.makeSpacer(height: 10)) // spacer
        
        // 연소득 슬라이더
        verticalStackView.addArrangedSubview(annualIncomeSlider)
        annualIncomeSlider.snp.makeConstraints { $0.height.equalTo(18) }
        
        verticalStackView.addArrangedSubview(self.makeSpacer(height: 6)) // spacer
        
        // 연소득 하단 라벨 (0원, 2500만원, 최대)
        let incomeLabelRow = UIStackView(arrangedSubviews: [annualIncomeMinLabel, annualIncomeMidLabel, annualIncomeMaxLabel]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        verticalStackView.addArrangedSubview(incomeLabelRow)
        verticalStackView.addArrangedSubview(self.makeSpacer(height: 20)) // spacer
        // 연령 행 (라벨)
        verticalStackView.addArrangedSubview(ageLabel)
        verticalStackView.addArrangedSubview(self.makeSpacer(height: 10)) // spacer
        // 만 ~ 세 입력 행
        let spacer = UIView()
        let ageInputRow = UIStackView(arrangedSubviews: [agePrefixLabel, ageTextField, ageSuffixLabel, spacer]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fill
        }
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        verticalStackView.addArrangedSubview(ageInputRow)
        ageTextField.snp.makeConstraints { $0.width.equalTo(120); $0.height.equalTo(46) }
    }
    
    private func makeSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.snp.makeConstraints { $0.height.equalTo(height) }
        return spacer
    }
}
