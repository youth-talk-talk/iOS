//
//  PolicyLocationKR.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/17/24.
//

import Foundation

enum PolicyLocationKR: Int, CaseIterable, PolicyLocation {
    
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
    
    var networkName: String {
        
        switch self {
        case .seoul:
            "서울"
        case .gyeonggi:
            "경기"
        case .incheon:
            "인천"
        case .sejong:
            "세종"
        case .daejeon:
            "대전"
        case .chungcheongNorth:
            "충북"
        case .chungcheongSouth:
            "충남"
        case .gangwon:
            "강원"
        case .gyeongsangNorth:
            "경북"
        case .gyeongsangSouth:
            "경남"
        case .daegu:
            "대구"
        case .ulsan:
            "울산"
        case .busan:
            "부산"
        case .gwangju:
            "광주"
        case .jeollaNorth:
            "전북"
        case .jeollaSouth:
            "전남"
        case .jeju:
            "제주"
        }
    }
    
    static var allCase: [PolicyLocation] {
        
        return self.allCases
    }
    
    static func fetchLocation(_ row: Int) -> PolicyLocation {
        
        return PolicyLocationKR(rawValue: row) ?? .seoul
    }
}
