//
//  APIManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa

enum TestError: Error {
    
    case invaildURL
}

final class APIManager: APIInterface {
    
    private let session: Session
    private let keyChainHelper = KeyChainHelper()
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func request<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, TestError>> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            session.request(router)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        single(.success(.success(success)))
                        
                        // HTTP 헤더 (Access Token, Refresh Token)
                        guard let httpResponse = response.response else { return }
                        
                        if let accessToken = httpResponse.value(forHTTPHeaderField: "Authorization") {
                            
                            self.keyChainHelper.saveTokenInfo(saveData: accessToken, type: .accessToken)
                        }
                        
                        if let refreshToken = httpResponse.value(forHTTPHeaderField: "Authorization-refresh") {
                            
                            self.keyChainHelper.saveTokenInfo(saveData: refreshToken, type: .refreshToken)
                        }
                        
                    case .failure(let error):
                        
                        print("❗️", "failure \(error)")
                        single(.success(.failure(TestError.invaildURL)))
                    }
                }
            
            return Disposables.create()
        }
    }
}
