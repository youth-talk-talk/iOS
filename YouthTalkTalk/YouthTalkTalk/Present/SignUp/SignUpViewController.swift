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
        
        let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        layoutView.regionDropDownView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                
                owner.layoutView.pullDownTableView.isHidden = !owner.layoutView.pullDownTableView.isHidden
                
            }.disposed(by: disposeBag)
    }
}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationKR.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let location = LocationKR(rawValue: indexPath.row) {
            
            cell.textLabel?.text = location.korean
            cell.textLabel?.font = FontManager.font(.bodyRegular)
            cell.textLabel?.textColor = .gray40
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 36
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let location = LocationKR(rawValue: indexPath.row) { layoutView.updateLocation(location) }
    }
}
