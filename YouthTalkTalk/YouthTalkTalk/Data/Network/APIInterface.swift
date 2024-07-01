//
//  APIInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/30/24.
//

import Foundation
import RxSwift

protocol APIInterface {
    
    func request<T: Decodable>(router: RouterInterface, type: T.Type) -> Single<Result<T, TestError>>
}
