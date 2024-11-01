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
        configureTabBarAppearance()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let useCase = SignInUseCaseImpl()
        let viewModel = SplashViewModel(signInUseCase: useCase)
        let rootVC = SplashViewController(viewModel: viewModel)
        let naviVC = UINavigationController(rootViewController: rootVC)
        
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
    
    private func configureTabBarAppearance() {
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowColor = .clear
        // 스크롤 엣지가 닿았을 때 탭바 appearance settings
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // 일반 탭바 appearance settings
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    static func makeRootVC() {
        
        let tabVC = UITabBarController()
        
        // HOME TAB
        let repository = PolicyRepositoryImpl()
        let policyUseCase = PolicyUseCaseImpl(policyRepository: repository)
        let homeViewModel = HomeViewModel(policyUseCase: policyUseCase)
        let homeVC = HomeViewController(viewModel: homeViewModel)
        let homeNaviVC = UINavigationController(rootViewController: homeVC)
        
        // COMMUNITY TAB
        let communityVC = CommunityTabViewController()
        let communityNaviVC = UINavigationController(rootViewController: communityVC)
        
        // MYPAGE TAB
        let myPageUseCase = PolicyUseCaseImpl(policyRepository: PolicyRepositoryImpl())
        let memberUseCase = MemberUseCaseImpl(memberRepository: MemberRepositoryImpl())
        let myPageViewModel = MyPageViewModel(useCase: myPageUseCase, memberUseCase: memberUseCase)
        let myPageVC = MyPageViewController(viewModel: myPageViewModel)
        let myPageNaviVC = UINavigationController(rootViewController: myPageVC)
        
        tabVC.setViewControllers([communityNaviVC, homeNaviVC, myPageNaviVC], animated: true)
        tabVC.selectedIndex = 1
        
        tabVC.tabBar.items?[0].image = UIImage(named: "community")?.withTintColor(.gray40, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[0].selectedImage = UIImage(named: "community")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        tabVC.tabBar.items?[1].image = UIImage(named: "house")?.withTintColor(.gray40, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[1].selectedImage = UIImage(named: "house")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        tabVC.tabBar.items?[2].image = UIImage(named: "profile")?.withTintColor(.gray40, renderingMode: .alwaysOriginal)
        tabVC.tabBar.items?[2].selectedImage = UIImage(named: "profile")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                fatalError("Failed to get SceneDelegate")
            }
            sceneDelegate.window?.rootViewController = tabVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}

