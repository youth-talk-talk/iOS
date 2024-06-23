//
//  AppCoordinator.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    
    func showSignInFlow()
    
    func showTabFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    var coordinatorType: CoordinatorType { .app }
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    required init(_ navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
}

extension AppCoordinator {
    
    func start() {
        
        // 유저 로그인 전 - showSignInFlow
        
        // 유저 로그인 후 - showTabFlow
    }
    
    func showSignInFlow() {
        
    }
    
    func showTabFlow() {
        
    }
}
