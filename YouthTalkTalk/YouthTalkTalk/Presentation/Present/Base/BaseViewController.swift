//
//  BaseViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        self.navigationItem.hidesBackButton = true
        self.updateNavigationBackButtonTitle()
        
        configureView()
        configureTableView()
        configureCollectionView()
        configureNavigation()
        bind()
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
}

extension BaseViewController {
    
    func errorHandler(_ error: APIError) {
        
        switch error {
        case .policyNotFound:
            showAlert(error)
        case .invalidAccessToken, .invalidRefreshToken:
            showAlert(error) { [weak self] _ in
                
                guard let self else { return }
                
                self.changeRootViewToSignIn()
            }
        default:
            showAlert(error)
        }
    }
    
    private func showAlert(_ error: APIError,_ handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "죄송합니다", message: error.msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func changeRootViewToSignIn() {
        
        let useCase = SignInUseCaseImpl()
        let viewModel = SignInViewModel(signInUseCase: useCase)
        let newRootVC = SignInViewController(viewModel: viewModel)
        let naviVC = UINavigationController(rootViewController: newRootVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                fatalError("Failed to get SceneDelegate")
            }
            sceneDelegate.window?.rootViewController = naviVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
