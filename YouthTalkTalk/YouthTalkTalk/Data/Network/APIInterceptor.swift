//
//  APIInterceptor.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/18/24.
//

import Foundation
import Alamofire

class APIInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        // 403 - 리프레쉬 토큰 추가
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("❗️ 엑세스 토큰 만료")
        
        let refreshToken = KeyChainHelper().loadTokenInfo(type: .refreshToken)
        
        guard var newRequest = request.request else {
            completion(.doNotRetry)
            return
        }
        
        newRequest.setValue(refreshToken, forHTTPHeaderField: "Authorization-refresh")
        
        completion(.retry)
    }
}
