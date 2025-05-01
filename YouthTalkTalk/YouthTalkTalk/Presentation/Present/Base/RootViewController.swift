//
//  RootViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit

class RootViewController: UIViewController {
    
    private(set) var backImageView = UIImageView(image: .back)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.backgroundColor = .white
        
        view.addSubview(backImageView)
        
        backImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(33)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        backImageView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
