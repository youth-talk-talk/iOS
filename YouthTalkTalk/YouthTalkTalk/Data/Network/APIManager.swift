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
            
            session.request(router, interceptor: interceptor).validate(statusCode: 200 ... 299)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        self.handleResponseHeaders(response.response)
                        single(.success(.success(success)))
                        
                    case .failure:
                        
                        let error = self.handleResponseError(from: response.data)
                        single(.success(.failure(error)))
                    }
                }
            
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
    
    /// response.data에서 code와 msg를 추출하는 함수
    private func handleResponseError(from data: Data?) -> APIError {
        guard let data = data else { return .unknown }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let code = jsonObject["code"] as? String {
                    print(code)
                    let error = APIError(code: code)
                    print(error.isSuccess ? "\(error.msg) - DTO 타입 전환 에러입니다": error.msg)
                    
                    return error
                }
            }
        } catch {
            print("Failed to parse JSON: \(error)")
        }
        
        return .unknown
    }
}
