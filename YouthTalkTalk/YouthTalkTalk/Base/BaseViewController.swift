//
//  BaseViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit
import RxSwift

class BaseViewController<LayoutView: UIView>: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var layoutView: LayoutView {
        return view as! LayoutView
    }
    
    override func loadView() {
        
        self.view = LayoutView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
        configureCollectionView()
        bind()
        
        updateNavigationBackButtonTitle(title: "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
    
    func configureView() { }
    
    func configureTableView() { }
    
    func configureCollectionView() { }
    
    func bind() { }
    
    func updateNavigationTitle(title: String) {
        
        let titleLabel = UILabel()
        titleLabel.designed(text: title, fontType: .subTitleForPolicyBold)
        self.navigationItem.titleView = titleLabel
    }
    
    func updateNavigationBackButtonTitle(title: String) {
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
    }
}
