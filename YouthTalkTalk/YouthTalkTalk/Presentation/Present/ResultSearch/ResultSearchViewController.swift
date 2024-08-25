//
//  ResultSearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa

enum ResultSearchSectionItems: Hashable {
    
    case condition
    case resultPolicy(PolicyEntity)
    case resultRP(RPEntity)
    
    var policy: PolicyEntity? {
        switch self {
        case .resultPolicy(let policyEntity):
            return policyEntity
        default: return nil
        }
    }
    
    var rp: RPEntity? {
        switch self {
        case .resultRP(let rpEntity):
            return rpEntity
        default: return nil
        }
    }
}

final class ResultSearchViewController: BaseViewController<ResultSearchView> {
    
    var viewModel: ResultSearchInterface
    var dataSource: UICollectionViewDiffableDataSource<ResultSearchLayout, ResultSearchSectionItems>!
    var snapshot = NSDiffableDataSourceSnapshot<ResultSearchLayout, ResultSearchSectionItems>()
    
    init(viewModel: ResultSearchInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellRegistration()
        headerRegistration()
    }
    
    override func bind() {
        
        snapshot.appendSections([.condition, .result])
        
        self.viewModel.output.searchListRelay
            .bind(with: self) { owner, items in
                owner.update(section: .result, items: items)
            }
            .disposed(by: disposeBag)
        
        self.viewModel.fetchSearchList.accept(())
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        // 인기정책 Section
        let resultSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, ResultSearchSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            if let policy = itemIdentifier.policy {
                cell.configure(data: policy)
            }
            
            if let rp = itemIdentifier.rp {
                cell.configure(data: rp)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = ResultSearchLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .result {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: resultSectionRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
            }
            
            return nil
        }
    }
    
    //MARK: Header Registration
    private func headerRegistration() {
        
        // TODO: Header View 바꿔라 중엽아
        
        // 조건선택 Header Registration
        let conditionHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
        }
        
        // 검색결과 Header Registration
        let resultHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { supplementaryView, elementKind, indexPath in
            
            supplementaryView.setTitle("-")
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            
                
            case TitleHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: resultHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }
    
    func update(section: ResultSearchLayout, items: [ResultSearchSectionItems]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
