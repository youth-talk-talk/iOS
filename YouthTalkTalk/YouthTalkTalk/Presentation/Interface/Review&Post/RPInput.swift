//
//  RPInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/10/24.
//

import Foundation
import RxCocoa

protocol RPInput {
    
    var fetchRPs: PublishRelay<Void> { get }
    var updateRecentRPs: PublishRelay<Int> { get }
    
    var policyCategorySeleted: PublishRelay<PolicyCategory>? { get }
}

extension RPInput {
    var policyCategorySeleted: PublishRelay<PolicyCategory>? {
        return nil // 기본적으로 nil 반환
    }
}
