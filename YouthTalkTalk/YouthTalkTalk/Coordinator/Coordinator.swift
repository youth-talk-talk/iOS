//
//  Coordinator.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit

protocol Coordinator: AnyObject {
    
    /// 코디네이터 타입 설정
    var coordinatorType: CoordinatorType { get }
    
    /// 코디네이터에 할당된 네비게이션 컨트롤러
    var navigationController: UINavigationController { get set }
    
    /// 자식 코디네이터 배열로 저장
    var childCoordinators: [Coordinator] { get set }
    
    /// 자식 코디네이터의 종료를 알려주는 Delegate
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    /// 코디네이터 시작 로직
    func start()
    
    /// 코디네이터 종료 로직,
    ///  모든 자식 코디네이터 삭제,
    ///  delegate에 종료 전달
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    
    func finish() {
        
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
