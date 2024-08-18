//
//  DetailPolicyOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/26/24.
//

import Foundation
import RxCocoa

protocol DetailPolicyOutput {
    
    var summarySectionRelay: PublishRelay<[PolicySectionItems]> { get }
    var detailSectionRelay: PublishRelay<[PolicySectionItems]> { get }
    var methodSectionRelay: PublishRelay<[PolicySectionItems]> { get }
    var targetSectionRelay: PublishRelay<[PolicySectionItems]> { get }
}
