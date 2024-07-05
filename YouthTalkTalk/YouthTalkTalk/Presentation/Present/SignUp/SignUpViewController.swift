//
//  SignUpViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit
import RxCocoa
import RxSwift

final class SignUpViewController: BaseViewController<SignUpView> {
    
    var viewModel: SignUpInterface
    let apiManager = APIManager()
    
    init(viewModel: SignUpInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // layoutView.signUpButton.addTarget(self, action: #selector(buttonTest), for: .touchUpInside)
    }
    
    // @objc
    // func buttonTest() {
    //     
    //     let region = layoutView.regionDropDownView.regionDropdownLabel.text!
    //     let identifier = KeyChainHelper().loadAppleInfo(type: .appleIdentifier)!
    //     let token = KeyChainHelper().loadAppleInfo(type: .appleIdentifierToken)!
    //     let nickname = layoutView.nicknameTextField.text!
    //     
    //     let body = SignUpBody(username: "3597174752",
    //                           nickname: "카카오이중엽",
    //                           region: "서울",
    //                           idToken: "",
    //                           signInType: .kakao)
    //     let router = SignUpRouter.requestKakaoSignUp(signUp: body)
    //     
    //     dump(router)
    //     
    //     
    //     apiManager.request(router: router, type: SignUpDTO.self)
    //         .subscribe(with: self) { owner, result in
    //             
    //             switch result {
    //             case .success(let success):
    //                 print(success)
    //             case .failure(let error):
    //                 dump(error)
    //             }
    //         }
    //         .disposed(by: disposeBag)
    // }
    
    override func bind() {
        
        layoutView.pullDownTableView.delegate = self
        layoutView.pullDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let gesture = layoutView.regionDropDownView.gestureRecognizers?.first else { return }
        
        // Dropdown(tableview) visible/hidden 토글
        gesture.rx.event
            .bind(with: self) { owner, _ in
                
                owner.layoutView.toggleTableViewHidden()
                
            }.disposed(by: disposeBag)
        
        layoutView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                
                guard let windowScene = UIApplication.shared.connectedScenes.first else { return }
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                
                let newRootVC = HomeViewController()
                let naviVC = UINavigationController(rootViewController: newRootVC)
                let tabVC = UITabBarController()
                
                tabVC.setViewControllers([naviVC], animated: true)
                
                sceneDelegate.window?.rootViewController = tabVC
                sceneDelegate.window?.makeKeyAndVisible()
                
                
                
            }.disposed(by: disposeBag)
        
        // MARK: Inputs
        layoutView.pullDownTableView.rx.itemSelected
            .bind(to: viewModel.itemSelectedEvent)
            .disposed(by: disposeBag)
        
        
        // MARK: Ouputs
        // Configure Cell
        viewModel.output.policyLocations
            .drive(layoutView.pullDownTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, location, cell in
                
                cell.textLabel?.designed(text: location.displayName, fontType: .p16Regular16, textColor: .gray40)
                cell.backgroundColor = .clear
                
            }.disposed(by: disposeBag)
        
        // Selected Item
        viewModel.output.selectedLocation
            .drive(with: self) { owner, policyLocation in
                
                owner.layoutView.updateLocation(policyLocation)
                
            }.disposed(by: disposeBag)
        
        // 이벤트 전달
        viewModel.input.policyLocationRelay.accept(())
    }
}

extension SignUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 36
    }
}
