//
//  PolicyViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/24/24.
//

import UIKit

enum PolicySection: Int, CaseIterable {
    
    case summary
    case target
    case method
    case detail
    case comments  // 댓글 섹션
    
    var title: String {
        switch self {
        case .summary: return "한눈에 보는 정책 요약!"
        case .target: return "누구를 위한 정책인가요?"
        case .method: return "신청방법이 궁금해요"
        case .detail: return "더 자세한 정보를 알려주세요"
        case .comments: return "댓글"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .summary: return .right
        case .target: return .person
        case .method: return .questionMark
        case .detail: return .plus
        case .comments: return nil
        }
    }
}

class PolicyViewController: BaseViewController<PolicyView> {
    
    let viewModel: DetailPolicyInterface
    
    init(viewModel: DetailPolicyInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        viewModel.fetchPolicyDetail.accept(viewModel.policyID)
    }
    
    override func configureTableView() {
        
        
    }
    
}
