//
//  BaseViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit

class BaseViewController<LayoutView: UIView>: UIViewController {
    
    var layoutView: UIView {
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.layoutView.endEditing(true)
    }
}

extension BaseViewController {
    
    func configureView() { }
    
    func configureTableView() { }
    
    func configureCollectionView() { }
    
    func bind() { }
}
