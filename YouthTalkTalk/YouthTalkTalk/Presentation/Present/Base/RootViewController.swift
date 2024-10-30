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
    
    func updateNavigationTitle(title: String) {
        
        let titleLabel = UILabel()
        titleLabel.designed(text: title, fontType: .p18Bold)
        self.navigationItem.titleView = titleLabel
    }
    
    func updateNavigationBackButtonTitle(title: String = "") {
        
        self.navigationItem.hidesBackButton = true
        
        let customBackView = UIImageView()
        customBackView.image = .back.withRenderingMode(.alwaysOriginal)
        let backButtonItem = UIBarButtonItem(customView: customBackView)
        
        let titleLabel = UILabel()
        titleLabel.designed(text: title, fontType: .p18Regular)
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backButtonItem, titleItem]
        
        // 뒤로 가기 동작 추가
        let tapGesture = UITapGestureRecognizer()
        customBackView.addGestureRecognizer(tapGesture)
        customBackView.isUserInteractionEnabled = true
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
}
