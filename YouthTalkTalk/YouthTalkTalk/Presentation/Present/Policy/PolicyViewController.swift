//
//  PolicyViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

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

enum PolicySectionItems: Hashable {
    
    case summary(DetailPolicyEntity.PolicySummary)
    case detail(DetailPolicyEntity.PolicyDetail)
    case method(DetailPolicyEntity.PolicyMethod)
    case target(DetailPolicyEntity.PolicyTarget)
    
    var identifier: String {
        
        switch self {
        case .summary(let policySummary):
            return SummaryTableViewCell.identifier
        case .detail(let policyDetail):
            return DetailTableViewCell.identifier
        case .method(let policyMethod):
            return MethodTableViewCell.identifier
        case .target(let policyTarget):
            return TargetTableViewCell.identifier
        }
    }
}

class PolicyViewController: BaseViewController<PolicyView> {
    
    var dataSource: UITableViewDiffableDataSource<PolicySection, PolicySectionItems>!
    var snapshot = NSDiffableDataSourceSnapshot<PolicySection, PolicySectionItems>()
    let viewModel: DetailPolicyInterface
    
    init(viewModel: DetailPolicyInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        snapshot.appendSections(PolicySection.allCases)
        
        viewModel.input.fetchPolicyDetail.accept(viewModel.policyID)
        
        viewModel.output.summarySectionRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .summary, items: sectionItems)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.detailSectionRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .detail, items: sectionItems)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.methodSectionRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .method, items: sectionItems)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.targetSectionRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .target, items: sectionItems)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureTableView() {
        
        layoutView.tableview.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
        layoutView.tableview.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        layoutView.tableview.register(MethodTableViewCell.self, forCellReuseIdentifier: MethodTableViewCell.identifier)
        layoutView.tableview.register(TargetTableViewCell.self, forCellReuseIdentifier: TargetTableViewCell.identifier)
        
        cellRegistration()
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        dataSource = UITableViewDiffableDataSource<PolicySection, PolicySectionItems>(tableView: layoutView.tableview) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
            
            switch item {
            case .summary(let summary):
                
                guard let cell = cell as? SummaryTableViewCell else { return UITableViewCell() }
                
                cell.test(summary)
                
                return cell
                
            case .detail(let detail):
                
                guard let cell = cell as? DetailTableViewCell else { return UITableViewCell() }
                
                return cell
                
            case .method(let method):
                
                guard let cell = cell as? MethodTableViewCell else { return UITableViewCell() }
                
                return cell
                
            case .target(let target):
                
                guard let cell = cell as? TargetTableViewCell else { return UITableViewCell() }
                
                return cell
            }
        }
    }
    
    func update(section: PolicySection, items: [PolicySectionItems]) {
            
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
