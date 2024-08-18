//
//  DebugViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import UIKit

enum DebugItem: Int, CaseIterable {
    
    case signInPage
    
    var name: String {
        
        switch self {
        case .signInPage:
            "회원가입 페이지 이동"
        }
    }
}

class DebugViewController: BaseViewController<DebugView> {
    
    private let keyChainHelper = KeyChainHelper()

    override func configureTableView() {
        
        layoutView.tableView.delegate = self
        layoutView.tableView.dataSource = self
        layoutView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DebugCell")
    }
    
    deinit {
        print("DebugViewController Deinit")
    }
}

extension DebugViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DebugItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebugCell", for: indexPath)
        let item = DebugItem(rawValue: indexPath.row) ?? .signInPage
        
        cell.backgroundColor = .clear
        cell.textLabel?.designed(text: item.name, fontType: .g20Bold, textColor: .white)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = DebugItem(rawValue: indexPath.row) ?? .signInPage
        
        switch item {
        case .signInPage:
            
            let useCase = SignInUseCaseImpl()
            let viewModel = SignInViewModel(signInUseCase: useCase)
            let newRootVC = SignInViewController(viewModel: viewModel)
            let naviVC = UINavigationController(rootViewController: newRootVC)
            
            resetSignInInfo()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                    fatalError("Failed to get SceneDelegate")
                }
                sceneDelegate.window?.rootViewController = naviVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func resetSignInInfo() {
        
        keyChainHelper.deleteTokenInfo(type: .accessToken)
        keyChainHelper.deleteTokenInfo(type: .refreshToken)
    }
}
