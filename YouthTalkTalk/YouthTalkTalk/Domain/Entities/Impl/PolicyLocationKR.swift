//
//  PolicyLocationKR.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/17/24.
//

import Foundation

enum PolicyLocationKR: Int, CaseIterable, PolicyLocationInterface {
    
    case seoul
    case gyeonggi
    case incheon
    case sejong
    case daejeon
    case chungcheongNorth
    case chungcheongSouth
    case gangwon
    case gyeongsangNorth
    case gyeongsangSouth
    case daegu
    case ulsan
    case busan
    case gwangju
    case jeollaNorth
    case jeollaSouth
    case jeju
    
    var displayName: String {
        
        switch self {
        case .seoul:
            "서울특별시"
        case .gyeonggi:
            "경기도"
        case .incheon:
            "인천광역시"
        case .sejong:
            "세종특별자치시"
        case .daejeon:
            "대전광역시"
        case .chungcheongNorth:
            "충청북도"
        case .chungcheongSouth:
            "충청남도"
        case .gangwon:
            "강원도"
        case .gyeongsangNorth:
            "경상북도"
        case .gyeongsangSouth:
            "경상남도"
        case .daegu:
            "대구광역시"
        case .ulsan:
            "울산광역시"
        case .busan:
            "부산광역시"
        case .gwangju:
            "광주광역시"
        case .jeollaNorth:
            "전라북도"
        case .jeollaSouth:
            "전라남도"
        case .jeju:
            "제주특별자치도"
        }
    }
    
    static var allCase: [PolicyLocationInterface] {
        
        return self.allCases
    }
    
    static func fetchLocation(_ row: Int) -> PolicyLocationInterface {
        
        return PolicyLocationKR(rawValue: row) ?? .seoul
    }
}
