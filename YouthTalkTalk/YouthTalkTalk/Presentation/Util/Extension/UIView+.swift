//
//  UIView+.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/6/24.
//

import UIKit

extension UIView {
    public func setShadow() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.withAlphaComponent(0.9).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
    }
    
    public func onTapped(_ handler: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerHandler = handler
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func roundTopCorners(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    typealias GestureHandler = (() -> Void)?
    
    private struct GestureAssociatedKey {
        /// Objective-C의 연관 객체 기능에서 고유한 주소를 키로 사용하기 위함
        /// 연관 객체를 저장하거나 검색할 때 사용되는 키 값, 실제 값이 아닌 변수의 주소가 중요
        ///
        /// UInt8 변수를 선언하고 초기값으로 0을 할당하는 것은, 이 변수의 주소를 고유한 키로 사용하기 위한 간단한 방법
        /// UInt8 타입은 메모리를 많이 차지하지 않으면서도 주소를 제공할 수 있는 타입
        fileprivate static var tapGestureKey: UInt8 = 0
    }
    
    private var tapGestureRecognizerHandler: GestureHandler? {
        get {
            return objc_getAssociatedObject(self,
                                            &GestureAssociatedKey.tapGestureKey) as? GestureHandler
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &GestureAssociatedKey.tapGestureKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerHandler, alpha == 1 {
            alpha = 0.5
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                action?()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.alpha = 1.0
            }
        }
    }
    
}
