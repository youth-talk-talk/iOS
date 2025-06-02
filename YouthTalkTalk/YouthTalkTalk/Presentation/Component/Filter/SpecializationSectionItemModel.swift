//
//  SpecializationSectionItemModel.swift
//  YouthTalkTalk
//
//  Created by SeokHyun on 6/3/25.
//

import Foundation

enum SpecializationSection {
    case occupationAndIndustry // 직업 / 산업
    case vulnerableGroups // 취약계층
    case others // 기타
    case maritalStatus // 혼인 여부
    
    var title: String {
        switch self {
        case .occupationAndIndustry: "직업 / 산업"
        case .vulnerableGroups: "취약계층"
        case .others: "기타"
        case .maritalStatus: "혼인 여부"
        }
    }
}

struct FilterDetailItem {
    let title: String
    var isSelected: Bool = false
}

struct SpecializationCategoryDataSource {
    let section: SpecializationSection
    let items: [FilterDetailItem]
}
