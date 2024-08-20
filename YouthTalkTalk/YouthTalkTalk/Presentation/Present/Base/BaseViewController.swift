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
        configureNavigation()
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
    
    func configureNavigation() { }
    
    func updateNavigationTitle(title: String) {
        
        let titleLabel = UILabel()
        titleLabel.designed(text: title, fontType: .p18Bold)
        self.navigationItem.titleView = titleLabel
    }
    
    private func updateNavigationBackButtonTitle(title: String) {
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
    }
    
    // deinit {
    //     print(String(describing: type(of: self)))
    // }
}

extension BaseViewController {
    
    func errorHandler(_ error: APIError) {
        
        switch error {
        case .policyNotFound:
            showAlert(error)
        default:
            break
        }
    }
    
    private func showAlert(_ error: APIError) {
        let alertController = UIAlertController(title: "죄송합니다", message: error.msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
