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
            
            session.request(router, interceptor: interceptor).validate(statusCode: 200 ... 399)
                .responseDecodable(of: type.self) { response in
                    
                    switch response.result {
                        
                    case .success(let success):
                        
                        self.handleResponseHeaders(response.response)
                        single(.success(.success(success)))
                        
                    case .failure:
                        print("[⚠️ Request 실패] \(response.response?.url ?? URL(string: ""))")
                        let error = self.handleResponseError(from: response.data)
                        single(.success(.failure(error)))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    public func postUploadImage(stringURL: String, image: Data) -> Single<Result<String, APIError>> {
        return Single.create { [weak self] single in
            let defaultHeader: HTTPHeaders = ["Content-Type": "multipart/form-data",
                                              "Authorization": "Bearer \(self!.keyChainHelper.loadTokenInfo(type: .accessToken))"]
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "image", fileName: "image.png")
                
            }, to: "\(APIKey.baseURL.rawValue)\(stringURL)", method: .post, headers: defaultHeader)
            .validate(statusCode: 200..<900)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let responseData = response.data {
                         do {
                             let decoder = JSONDecoder()
                             let decodedResponse = try decoder.decode(UploadImageDTO.self, from: responseData)

                             single(.success(.success(decodedResponse.data)))
                         } catch {
                             print("Error decoding response:", error)
                             single(.success(.failure(APIError(code: "999"))))
                         }
                     }                
                case .failure(_):
                    if let error = self?.handleResponseError(from: response.data) {
                        single(.success(.failure(error)))
                    }
                }
            }
            
            return Disposables.create()
        }
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
                    let error = APIError(code: code)
                    return error
                }
            }
        } catch {
        }
        
        return .unknown
    }
}
