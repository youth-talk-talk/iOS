//
//  Router.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var body: Data? { get }
}

extension Router {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.allHTTPHeaderFields = headers?.dictionary
        urlRequest.httpBody = body
        
        var queryItems = [URLQueryItem]()
        
        if let parameters {
            
            for value in parameters {
                let queryItem = URLQueryItem(name: value.key, value: "\(value.value)")
                queryItems.append(queryItem)
            }
        }
        
        if #available(iOS 16.0, *) {
            urlRequest.url?.append(queryItems: queryItems)
        } else {
            if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false) {
                let existingQueryItems = urlComponents.queryItems ?? []
                urlComponents.queryItems = existingQueryItems + queryItems
                urlRequest.url = urlComponents.url
            }
        }
        
        return urlRequest
    }
}
