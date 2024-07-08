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
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func request<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, TestError>> {
        
        // dump(router)
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            session.request(router)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        single(.success(.success(success)))
                        
                        // print("❗️", response.response?.allHeaderFields["Authorization"])
                        // print("❗️", response.response?.allHeaderFields["Authorization-refresh"])
                        
                    case .failure(let error):
                        
                        dump(error)
                        print(response.response!.statusCode)
                        print("❗️", "failure")
                        single(.success(.failure(TestError.invaildURL)))
                    }
                }
            
            return Disposables.create()
        }
    }
}
