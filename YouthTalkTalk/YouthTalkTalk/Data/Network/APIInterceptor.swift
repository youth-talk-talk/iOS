//
//  APIInterceptor.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/18/24.
//

import Foundation
import Alamofire
import UIKit

class APIInterceptor: RequestInterceptor {
    
    private let keyChainHelper = KeyChainHelper()
    private let userDefaultsHelper = UserDefaults.standard
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var adaptedRequest = urlRequest
        let accessToken = keyChainHelper.loadTokenInfo(type: .accessToken)
        
        adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(adaptedRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403  else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 엑세스 토큰 만료
        print("❗️ 엑세스 토큰 만료")
        let refreshToken = KeyChainHelper().loadTokenInfo(type: .refreshToken)
        
        guard var newRequest = request.request else {
            completion(.doNotRetry)
            return
        }
        
        newRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization-refresh")
        newRequest.setValue(nil, forHTTPHeaderField: "Authorization")
        
        session.request(newRequest).validate(statusCode: 200 ... 400).response { response in
            print("❗️ 엑세스 토큰 재발급")
            
            switch response.result {
            case .success(let success):
                
                print("❗️ 엑세스 토큰 재발급 성공")
                self.handleResponseHeaders(response.response)
                // 새로 발급 받은 엑세스 토큰과 리프레쉬 토큰을 저장해서 다시 시도
                completion(.retry)
                
            case .failure(let error):
                
                if response.response?.statusCode == 401 {
                    self.handleRefreshTokenExpired()
                    completion(.doNotRetryWithError(error))
                }
                
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

extension APIInterceptor {
    private func handleResponseHeaders(_ response: HTTPURLResponse?) {
        
        guard let httpResponse = response else { return }
        
        self.keyChainHelper.saveTokenInfoFromHttpResponse(response: httpResponse)
    }
    
    // 리프레시 토큰 만료 처리
    private func handleRefreshTokenExpired() {
        
        moveToSignInVC()
    }
    
    private func moveToSignInVC() {
        // 여기서 사용자에게 알림을 제공하거나 로그인 화면으로 이동하는 로직을 구현
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "세션 만료", message: "다시 로그인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                
                guard let self else { return }
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
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
            }))
            
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func resetSignInInfo() {
        
        keyChainHelper.deleteTokenInfo(type: .accessToken)
        keyChainHelper.deleteTokenInfo(type: .refreshToken)
    }
}
