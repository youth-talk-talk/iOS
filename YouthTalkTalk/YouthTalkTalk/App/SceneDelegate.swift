//
//  SceneDelegate.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit
import KakaoSDKAuth
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        configureNavigationAppearance()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let useCase = AutoSignInUseCase(userDefaultsRepository: UserDefaultsRepositoryImpl(),
                                        keyChainRepository: KeyChainRepositoryImpl())
        let viewModel = SplashViewModel(autoSignInUseCase: useCase)
        let rootVC = SplashViewController(viewModel: viewModel)
        let naviVC = UINavigationController(rootViewController: rootVC)
        
        // let useCase = AppleSignInUseCase()
        // let viewModel = SignInViewModel(appleSignInUseCase: useCase)
        // let rootVC = SignInViewController(viewModel: viewModel)
        // let naviVC = UINavigationController(rootViewController: rootVC)
        
        self.window = window
        
        self.window?.rootViewController = naviVC
        self.window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: Navigation bar appearance
    private func configureNavigationAppearance() {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.shadowColor = .clear
        
        // 일반 네이게이션 바 appearance settings
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        // 랜드스케이프 되었을 때 네이게이션 바 appearance settings
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        // 스크롤 엣지가 닿았을 때 네이게이션 바 appearance settings
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}

