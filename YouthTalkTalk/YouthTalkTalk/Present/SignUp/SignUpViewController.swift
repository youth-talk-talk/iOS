//
//  SignUpViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit
import RxCocoa

class SignUpViewController: BaseViewController<SignUpView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        layoutView.pullDownTableView.delegate = self
        layoutView.pullDownTableView.dataSource = self
        layoutView.pullDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        layoutView.pullDownTableView.estimatedRowHeight = UITableView.automaticDimension
        
        layoutView.regionPopupButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.layoutView.pullDownTableView.isHidden = !owner.layoutView.pullDownTableView.isHidden
                
            }.disposed(by: disposeBag)
    }
}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .brown
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
