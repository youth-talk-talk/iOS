//
//  AppDelegate.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 5/12/24.
//

import UIKit
import RxKakaoSDKCommon
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let nativeAppKey: String = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
        RxKakaoSDK.initSDK(appKey: nativeAppKey)
        
        // let appleIDProvider = ASAuthorizationAppleIDProvider()
        // appleIDProvider.getCredentialState(forUserID: "000671.1be2acb55be547ee958844fe27c65ee1.1521") { (credentialState, error) in
        //     switch credentialState {
        //     case .authorized:
        //         print("✏️ 애플 로그인 유효합니다")
        //         break // The Apple ID credential is valid.
        //     case .revoked, .notFound:
        //         // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
        //         break
        //     default:
        //         break
        //     }
        // }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

