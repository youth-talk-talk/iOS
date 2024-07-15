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
    private let keyChainRepository: KeyChainRepository
    
    init(session: Session = Session.default, keyChainRepository: KeyChainRepository = KeyChainRepositoryImpl()) {
        self.session = session
        self.keyChainRepository = keyChainRepository
    }
    
    func request<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, APIError>> {
        
        return Single.create { [weak self] single in
            
            guard let self else { return Disposables.create() }
            
            session.request(router)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        single(.success(.success(success)))
                        self.handleResponseHeaders(response.response)
                        
                    case .failure(let error):
                        
                        let error: APIError = self.handleErrorResponse(response.data)
                        
                        single(.success(.failure(error)))
                        
                    }
                }
            
            return Disposables.create()
        }
    }
}

extension APIManager {
    
    private func handleResponseHeaders(_ response: HTTPURLResponse?) {
        
        guard let httpResponse = response else { return }
        
        if let accessToken = httpResponse.value(forHTTPHeaderField: "Authorization") {
            self.keyChainRepository.saveTokenInfo(saveData: accessToken, type: .accessToken)
        }
        
        if let refreshToken = httpResponse.value(forHTTPHeaderField: "Authorization-refresh") {
            self.keyChainRepository.saveTokenInfo(saveData: refreshToken, type: .refreshToken)
        }
    }
    
    private func handleErrorResponse(_ data: Data?) -> APIError {
        
        var error = APIError(code: "알수없음")
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let errorDict = json as? [String: Any] {
                    if let status = errorDict["status"] as? Int {
                        print("에러 상태 코드: \(status)")
                    }
                    if let message = errorDict["message"] as? String {
                        print("에러 메시지: \(message)")
                    }
                    if let code = errorDict["code"] as? String {
                        print("에러 코드: \(code)")
                        error = .init(code: code)
                    }
                }
            } catch {
                print("JSON 파싱 오류: \(error)")
            }
        }
        
        return error
    }
}
