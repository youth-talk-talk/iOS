//
//  PolicyViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/24/24.
//

import UIKit

class PolicyViewController: BaseViewController<PolicyView> {
    
    let testData: PolicyEntity
    
    init(testData: PolicyEntity) {
        self.testData = testData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dump(testData)
    }

}
