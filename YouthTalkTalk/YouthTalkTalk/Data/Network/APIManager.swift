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
    
    private let keyChainHelper: KeyChainHelper = KeyChainHelper()
    private let interceptor: APIInterceptor = APIInterceptor()
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func request<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, APIError>> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            session.request(router, interceptor: interceptor)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        self.handleResponseHeaders(response.response)
                        single(.success(.success(success)))
                        
                    case .failure:
                        
                        let error = self.handleResponseError(response.response)
                        single(.success(.failure(error)))
                        
                    }
                }
            
            single(.success(.failure(APIError.unknown)))
            print(APIError.unknown.msg)
            
            return Disposables.create()
        }
    }
    
    deinit {
        print("APIManager Deinit")
    }
}

extension APIManager {
    
    /// 토큰 정보 저장
    private func handleResponseHeaders(_ response: HTTPURLResponse?) {
        
        guard let httpResponse = response else { return }
        
        self.keyChainHelper.saveTokenInfoFromHttpResponse(response: httpResponse)
    }
    
    /// 에러 타입 반환 및 오류메시지 프린트
    private func handleResponseError(_ response: HTTPURLResponse?) -> APIError {
        
        guard let httpResponse = response else { return APIError.unknown }
        
        let error = APIError.init(code: String(httpResponse.statusCode))
        
        print(error.isSuccess ? "\(error.msg) - DTO 타입 전환 에러입니다": error.msg)
        
        return error
    }
}
