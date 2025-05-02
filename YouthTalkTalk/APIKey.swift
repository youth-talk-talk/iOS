//
//  APIKey.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/22/24.
//

import Foundation

enum APIKey: String {
#if RELEASE
    case baseURL = "http://43.202.212.173/api/v1"
#elseif DEBUG
    case baseURL = "http://13.209.36.122/api/v1"
#endif
}
