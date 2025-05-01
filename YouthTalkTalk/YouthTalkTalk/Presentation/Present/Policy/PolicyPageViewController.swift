//
//  PolicyPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class PolicyPageViewController: UIViewController {
    let policies: [PolicyDTO] = [.init(policyId: "", category: "주제",
                                       title: "정책 타이틀입니다.",
                                       deadlineStatus: "상태",
                                       hostDep: "host",
                                       scrap: false),
                                 .init(policyId: "", category: "주제",
                                       title: "정책 타이틀입니다.",
                                       deadlineStatus: "상태",
                                       hostDep: "host",
                                       scrap: false),
                                 .init(policyId: "", category: "주제",
                                       title: "정책 타이틀입니다.",
                                       deadlineStatus: "상태",
                                       hostDep: "host",
                                       scrap: false),
                                 .init(policyId: "", category: "주제",
                                       title: "정책 타이틀입니다.",
                                       deadlineStatus: "상태",
                                       hostDep: "host",
                                       scrap: false)]
    
    private let policyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderate(16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(policyStackView)
        
        policyStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        policies.forEach { policy in
            let policyView = NewPolicyView()
            policyView.setStyle(.border)
            policyStackView.addArrangedSubview(policyView)
        }
    }
}
