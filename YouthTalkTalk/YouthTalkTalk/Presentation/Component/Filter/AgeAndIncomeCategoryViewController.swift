//
//  AgeAndIncomeCategoryViewController.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/3/25.
//

import UIKit
import SnapKit
import Then
import MultiSlider

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
    
    private let incomeSteps: [Int] = [
        0,
        1200, 1400, 1600, 1800, 2000,
        2100, 2200, 2300, 2400, 2500,
        2750, 3000, 3250, 3500, 3750, 4000, 4250, 4500, 4750, 5000
    ]
    
    private lazy var annualIncomeSlider = MultiSlider().then {
        $0.minimumValue = 0
        $0.maximumValue = CGFloat(incomeSteps.count - 1)
        $0.value = [0, CGFloat(incomeSteps.count - 1)]
        $0.snapStepSize = 1
        $0.tintColor = .greenNormal
        $0.outerTrackColor = .gray70
        $0.trackWidth = 4
        $0.thumbTintColor = .white
        $0.keepsDistanceBetweenThumbs = true
        $0.orientation = .horizontal
        $0.distanceBetweenThumbs = 1 // 두 원의 사이 최소 간격
        let thumbImage = self.makeCircleImage(diameter: 16, color: .white)
        $0.thumbImage = thumbImage
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
        $0.keyboardType = .numberPad
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
        applyThumbShadow()
        annualIncomeSlider.addTarget(self, action: #selector(incomeSliderChanged), for: .valueChanged)
        updateIncomeLabel()
        setupKeyboardDismissGesture()
        setupTextFieldAccessory()
    }
    
    // MARK: - SetupUI
    private func applyThumbShadow() {
      for thumb in annualIncomeSlider.thumbViews {
        thumb.layer.shadowColor = UIColor.black.cgColor
        thumb.layer.shadowOpacity = 0.15
        thumb.layer.shadowOffset = CGSize(width: 0, height: 2)
        thumb.layer.shadowRadius = 4
        thumb.layer.masksToBounds = false
      }
    }
    
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
        
        // 연소득 MultiSlider
        verticalStackView.addArrangedSubview(annualIncomeSlider)
        annualIncomeSlider.snp.makeConstraints { $0.height.equalTo(32) }
        
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
    
    
    // MARK: - Private
    private func makeCircleImage(diameter: CGFloat, color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func makeSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.snp.makeConstraints { $0.height.equalTo(height) }
        return spacer
    }
    
    @objc private func incomeSliderChanged() {
        updateIncomeLabel()
    }
    
    private func updateIncomeLabel() {
        let minIndex = Int(annualIncomeSlider.value[0])
        let maxIndex = Int(annualIncomeSlider.value[1])
        let minValue = incomeSteps[minIndex]
        let maxValue = incomeSteps[maxIndex]
        if maxIndex == incomeSteps.count - 1 {
            slidedAnnualIncomeLabel.text = "\(formatIncome(maxValue))만원 이상"
        } else if minIndex == maxIndex {
            slidedAnnualIncomeLabel.text = "\(formatIncome(minValue))만원"
        } else {
            slidedAnnualIncomeLabel.text = "\(formatIncome(minValue))만원 ~ \(formatIncome(maxValue))만원"
        }
    }
    
    private func formatIncome(_ value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    // 화면 탭 시 키보드 내리기
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 키보드에 확인 버튼 추가
    private func setupTextFieldAccessory() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        ageTextField.inputAccessoryView = toolbar
    }
}
