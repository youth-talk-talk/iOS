//
//  RootViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let customBackButton = UIButton(type: .system)
        customBackButton.setImage(.back.withRenderingMode(.alwaysOriginal), for: .normal)

         customBackButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
         
         let backBarButtonItem = UIBarButtonItem(customView: customBackButton)
         navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
