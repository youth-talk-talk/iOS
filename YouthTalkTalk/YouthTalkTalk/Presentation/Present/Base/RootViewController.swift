//
//  RootViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    
    let flexView = UIView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(flexView)
        
        configureView()
        configureLayout()
        configureTableView()
        configureCollectionView()
        configureNavigation()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func configureView() { }
    
    func configureLayout() { }
    
    func configureTableView() { }
    
    func configureCollectionView() { }
    
    func bind() { }
    
    func configureNavigation() { }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
}
