//
//  CommunityViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa

enum CommunitySectionItems: Hashable {
    
    case search
    case popular(RPEntity)
    case recent(RPEntity)
    
    var data: RPEntity? {
        switch self {
        case .search:
            return nil
        case .popular(let rpEntity):
            return rpEntity
        case .recent(let rpEntity):
            return rpEntity
        }
    }
}

class CommunityViewController: BaseViewController<CommunityView> {
    
    let viewModel: RPInterface
    
    var dataSource: UICollectionViewDiffableDataSource<CommunityLayout, CommunitySectionItems>!
    var snapshot = NSDiffableDataSourceSnapshot<CommunityLayout, CommunitySectionItems>()

    init(viewModel: RPInterface) {
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
        
        snapshot.appendSections([.search, .popular, .recent])
        
        layoutView.createButton.rx.tap
            .bind(with: self) { owner, _ in
                
                let nextVC = NewPostViewController()
                
                owner.tabmanParent?.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.popularRPsRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .popular, items: sectionItems)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.recentRPsRelay
            .bind(with: self) { owner, sectionItems in
                
                owner.update(section: .recent, items: sectionItems)
            }
            .disposed(by: disposeBag)
        
        viewModel.input.fetchRPs.accept(())
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        // 인기정책 Section
        let popularSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, CommunitySectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier.data)
        }
        
        // 최근 업데이트 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, CommunitySectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier.data)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = CommunityLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .search { return nil }
            
            if section == .popular {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: popularSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
            
            if section == .recent {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentSectionRegistration, for: indexPath, item: itemIdentifier)
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
            
            return nil
        }
    }
    
    //MARK: Header Registration
    private func headerRegistration() {
        
        // 카테고리 Header Registration
        let searchHeaderRegistration = UICollectionView.SupplementaryRegistration<SearchHeaderView>(elementKind: SearchHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            let type = self.viewModel.type
            
            supplementaryView.searchButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    let viewModel = SearchViewModel(type: type)
                    
                    let nextVC = SearchViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: supplementaryView.disposeBag)
            
            if type == .review {
                supplementaryView.configureWithCategory()
            } else if type == .post {
                supplementaryView.configureWithOutCategory()
            }
            
            
            let jobButtonTap = supplementaryView.jobCheckBoxButton.rx.tap.map { PolicyCategory.job }.asObservable()
            let educationButtonTap = supplementaryView.educationCheckBoxButton.rx.tap.map { PolicyCategory.education }.asObservable()
            let lifeButtonTap = supplementaryView.lifeCheckBoxButton.rx.tap.map { PolicyCategory.life }.asObservable()
            let participationButtonTap = supplementaryView.participationCheckBoxButton.rx.tap.map { PolicyCategory.participation }.asObservable()
            
            Observable.merge(jobButtonTap, educationButtonTap, lifeButtonTap, participationButtonTap)
                .bind(with: self) { owner, category in
                    
                    // 선택 시 'seleted' 활성화/비활성화
                    switch category {
                    case .job:
                        supplementaryView.jobCheckBoxButton.isSelected.toggle()
                    case .education:
                        supplementaryView.educationCheckBoxButton.isSelected.toggle()
                    case .life:
                        supplementaryView.lifeCheckBoxButton.isSelected.toggle()
                    case .participation:
                        supplementaryView.participationCheckBoxButton.isSelected.toggle()
                    }
                    
                    // 선택된 버튼만 필터링
                    let selectedButtons = [
                        supplementaryView.jobCheckBoxButton,
                        supplementaryView.educationCheckBoxButton,
                        supplementaryView.lifeCheckBoxButton,
                        supplementaryView.participationCheckBoxButton
                    ].filter { $0.isSelected }
                    
                    // 선택된 버튼이 없으면, 마지막으로 클릭한 버튼 'selected'
                    if selectedButtons.isEmpty {
                        switch category {
                        case .job:
                            supplementaryView.jobCheckBoxButton.isSelected = true
                        case .education:
                            supplementaryView.educationCheckBoxButton.isSelected = true
                        case .life:
                            supplementaryView.lifeCheckBoxButton.isSelected = true
                        case .participation:
                            supplementaryView.participationCheckBoxButton.isSelected = true
                        }
                    }
                }.disposed(by: supplementaryView.disposeBag)
            
        }
        
        // 인기정책 Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { supplementaryView, elementKind, indexPath in
            
            let section = indexPath.section
            let layout = CommunityLayout(rawValue: section)
            
            switch layout {
            case .popular:
                
                supplementaryView.setTitle("인기 게시물")
                
            case .recent:
                
                supplementaryView.setTitle("최근 게시물")
                
            default: return
            }
            
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case SearchHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: searchHeaderRegistration,
                    for: index)
                
            case TitleHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }

    func update(section: CommunityLayout, items: [CommunitySectionItems]) {
            
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
