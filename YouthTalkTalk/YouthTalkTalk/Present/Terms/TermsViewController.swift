//
//  TermsViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/15/24.
//

import UIKit

class TermsViewController: BaseViewController<TermsView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Pretendard-Bold", size: 18) ?? .systemFont(ofSize: 18)]
        
        self.navigationItem.title = "진짜"
    }
    
}
