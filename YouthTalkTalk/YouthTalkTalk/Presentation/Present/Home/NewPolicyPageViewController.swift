//
//  NewPolicyPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/14/25.
//

import UIKit

final class NewPolicyPageViewController: UIViewController {
    private let policies: [PolicyDTO]
    
    init(policies: [PolicyDTO]) {
        self.policies = policies
        
        super.init(nibName: nil, bundle: nil)
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = moderate(14)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        policies.forEach { policy in
            let view = NewPolicyView()
            view.setStyle(.border)
            view.setData(policy)
            
            stackView.addArrangedSubview(view)

            view.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(moderate(121))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
