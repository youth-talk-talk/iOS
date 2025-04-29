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
        case .summary: return .addPhoto
        case .target: return .addPhoto
        case .method: return .addPhoto
        case .detail: return .addPhoto
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
        case .summary:
            return SummaryTableViewCell.identifier
        case .detail:
            return DetailTableViewCell.identifier
        case .method:
            return MethodTableViewCell.identifier
        case .target:
            return TargetTableViewCell.identifier
        }
    }
}

final class PolicyViewController: RootViewController {
    private let tableview = UITableView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
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
//    
//    override func bind() {
//        tabBarController?.tabBar.isHidden = true
//
//        snapshot.appendSections(PolicySection.allCases)
//        
//        viewModel.input.fetchPolicyDetail.accept(viewModel.policyID)
//        
//        viewModel.output.summarySectionRelay
//            .bind(with: self) { owner, sectionItems in
//                
//                owner.update(section: .summary, items: sectionItems)
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.output.detailSectionRelay
//            .bind(with: self) { owner, sectionItems in
//                
//                owner.update(section: .detail, items: sectionItems)
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.output.methodSectionRelay
//            .bind(with: self) { owner, sectionItems in
//                
//                owner.update(section: .method, items: sectionItems)
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.output.targetSectionRelay
//            .bind(with: self) { owner, sectionItems in
//                
//                owner.update(section: .target, items: sectionItems)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    override func configureTableView() {
//        view.backgroundColor = .white
//        
//        view.addSubview(backImageView)
//        view.addSubview(tableview)
//        
//        backImageView.onTapped { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }
//        
//        backImageView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
//            $0.leading.equalToSuperview().inset(18)
//            $0.size.equalTo(24)
//        }
//
//        tableview.snp.makeConstraints {
//            $0.top.equalTo(backImageView.snp.bottom).offset(13)
//            $0.leading.trailing.equalToSuperview().inset(17)
//            $0.bottom.equalToSuperview()
//        }
//        
//        tableview.rowHeight = UITableView.automaticDimension
//        tableview.sectionHeaderTopPadding = 0
//        tableview.sectionHeaderHeight = 0
//        tableview.sectionFooterHeight = 0
//        
//        tableview.register(SummaryTableViewCell.self, forCellReuseIdentifier: SummaryTableViewCell.identifier)
//        tableview.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
//        tableview.register(MethodTableViewCell.self, forCellReuseIdentifier: MethodTableViewCell.identifier)
//        tableview.register(TargetTableViewCell.self, forCellReuseIdentifier: TargetTableViewCell.identifier)
//        
//        cellRegistration()
//    }
//    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        dataSource = UITableViewDiffableDataSource<PolicySection, PolicySectionItems>(tableView: tableview) { tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
            
            switch item {
            case .summary(let summary):
                
                guard let cell = cell as? SummaryTableViewCell else { return UITableViewCell() }
                
                cell.configure(summary)
                
                return cell
                
            case .target(let target):
                
                guard let cell = cell as? TargetTableViewCell else { return UITableViewCell() }
                
                cell.configure(target)
                
                return cell
                
            case .method(let method):
                
                guard let cell = cell as? MethodTableViewCell else { return UITableViewCell() }
                
                cell.configure(method)
                
                return cell
                
            case .detail(let detail):
                
                guard let cell = cell as? DetailTableViewCell else { return UITableViewCell() }
                
                cell.configure(detail)
                
                return cell
            }
        }
    }
    
    func update(section: PolicySection, items: [PolicySectionItems], animating: Bool = false) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: animating)
    }
    
}
