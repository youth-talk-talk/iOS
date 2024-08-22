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
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401  else {
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
        
        // 리프레쉬 토큰 추가하여 엑세스 토큰 재발급 요청
        session.request(newRequest).validate(statusCode: 200 ... 400).response { response in
            
            switch response.result {
            case .success:
                
                print("❗️ 엑세스 토큰 재발급 성공")
                self.handleResponseHeaders(response.response)
                // 새로 발급 받은 엑세스 토큰과 리프레쉬 토큰을 저장해서 다시 시도
                completion(.retry)
                
            case .failure:
                
                print("❗️ 엑세스 토큰 재발급 실패")
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
}
