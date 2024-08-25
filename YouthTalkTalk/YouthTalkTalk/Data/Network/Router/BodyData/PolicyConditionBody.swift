//
//  PolicyConditionBody.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/25/24.
//

import Foundation

struct PolicyConditionBody: Encodable {
    
    // "categories": ["LIFE","JOB"], // null의 경우 전체 선택
    // "age": 25, // null의 경우 나이 제한X
    // "employmentCodeList": ["EMPLOYED", "NO_RESTRICTION","OTHER"], // null의 경우 전체 선택
    // "isFinished": false, // null의 경우 전체 선택
    // "keyword": "전세" // null의 경우 키워드 제한X
    
    var categories: [String]
    var age: Int?
    var employmentCodeList: [String]
    var isFinished: Bool?
    var keyword: String
    
    init(categories: [String], age: Int?, employmentCodeList: [String], isFinished: Bool?, keyword: String) {
        self.categories = categories
        self.age = age
        self.employmentCodeList = employmentCodeList
        self.isFinished = isFinished
        self.keyword = keyword
    }
}
