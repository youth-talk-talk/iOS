//
//  HomeViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/18/24.
//

import UIKit
import PinLayout
import RxCocoa
import RxSwift

enum HomeSectionItems: Hashable {
    
    case category
    case popular(PolicyEntity)
    case recent(PolicyEntity)
    
    var data: PolicyEntity? {
        switch self {
        case .category:
            return nil
        case .popular(let policyEntity):
            return policyEntity
        case .recent(let policyEntity):
            return policyEntity
        }
    }
}

final class HomeViewController: BaseViewController<HomeView> {
    
    var viewModel: HomeInterface
    var dataSource: UICollectionViewDiffableDataSource<HomeLayout, HomeSectionItems>!
    var snapshot = NSDiffableDataSourceSnapshot<HomeLayout, HomeSectionItems>()
    
    init(viewModel: HomeInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCollectionView() {
        
        layoutView.collectionView.prefetchDataSource = self
        
        cellRegistration()
        headerRegistration()
    }
    
    override func bind() {
        
        snapshot.appendSections([.category, .popular, .recent])
        
        viewModel.output.popularPoliciesRelay
            .bind(with: self) { owner, popularPolicies in
                
                owner.update(section: .popular, items: popularPolicies)
                
            }.disposed(by: disposeBag)
        
        viewModel.output.recentPoliciesRelay
            .bind(with: self) { owner, recentPolicies in
                
                owner.update(section: .recent, items: recentPolicies)
                
            }.disposed(by: disposeBag)
        
        viewModel.output.resetSectionItems
            .bind(with: self) { owner, _ in
                
                owner.snapshot.deleteItems(owner.snapshot.itemIdentifiers(inSection: .recent))
                
                owner.dataSource.apply(owner.snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.errorHandler
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        viewModel.input.fetchPolicies.accept(())
        
        layoutView.collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                let homeLayout = HomeLayout(rawValue: indexPath.section) ?? .category
                let items = owner.dataSource.snapshot().itemIdentifiers(inSection: homeLayout)
                
                guard let item = items[indexPath.item].data else { return }
                
                switch homeLayout {
                case .popular, .recent:
                    
                    let repository = PolicyRepositoryImpl()
                    let useCase = PolicyUseCaseImpl(policyRepository: repository)
                    let viewModel = PolicyViewModel(policyID: item.policyId, policyUseCase: useCase)
                    let nextVC = PolicyViewController(viewModel: viewModel)
                    
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
        
        // 인기정책 Section
        let popularSectionRegistration = UICollectionView.CellRegistration<PopularCollectionViewCell, HomeSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self,
                  let data = itemIdentifier.data else { return }
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.configure(data: data)
            
            // cell에 적용(스크롤시에도 유지)
            if let scrap = viewModel.output.scrapStatus[data.policyId] {
                cell.updateScrapStatus(scrap)
            }
            
            // cell에 즉시 적용
            viewModel.output.scrapStatusRelay
                .bind(with: self) { owner, scrapStatus in
                    if let scrap = scrapStatus[data.policyId] {
                        cell.updateScrapStatus(scrap)
                    }
                }
                .disposed(by: self.disposeBag)
            
            cell.scrapButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    owner.viewModel.input.updatePolicyScrap.accept(data.policyId)
                }
                .disposed(by: cell.disposeBag)
        }
        
        // 최근 업데이트 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, HomeSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self,
                  let data = itemIdentifier.data else { return }
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.configure(data: data)
            
            // cell에 적용(스크롤시에도 유지)
            if let scrap = viewModel.output.scrapStatus[data.policyId] {
                cell.updateScrapStatus(scrap)
            }
            
            // cell에 즉시 적용
            viewModel.output.scrapStatusRelay
                .bind(with: self) { owner, scrapStatus in
                    if let scrap = scrapStatus[data.policyId] {
                        cell.updateScrapStatus(scrap)
                    }
                }
                .disposed(by: self.disposeBag)
            
            cell.scrapButton.rx.tap
                .bind(with: self) { owner, _ in
                    owner.viewModel.input.updatePolicyScrap.accept(data.policyId)
                }
                .disposed(by: cell.disposeBag)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = HomeLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .popular {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: popularSectionRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
            }
            
            if section == .recent {
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: recentSectionRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
            }
            
            return nil
        }
    }
    
    //MARK: Header Registration
    private func headerRegistration() {
        
        // 카테고리 Header Registration
        let categoryHeaderRegistration = UICollectionView.SupplementaryRegistration<CategoryButtonHeaderView>(elementKind: CategoryButtonHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            supplementaryView.searchButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    let viewModel = SearchViewModel(type: .policy)
                    
                    let nextVC = SearchViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: supplementaryView.disposeBag)
        }
        
        // 인기정책 Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { supplementaryView, elementKind, indexPath in
            
            supplementaryView.setTitle("인기 정책")
        }
        
        // 최근업데이트 Header Registration
        let recentHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleWithCategoryHeaderView>(elementKind: TitleWithCategoryHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
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
                    } else {
                        
                        owner.viewModel.input.policyCategorySeleted.accept(category)
                    }
                }.disposed(by: supplementaryView.disposeBag)
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
            case CategoryButtonHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: categoryHeaderRegistration,
                    for: index)
                
            case TitleHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularHeaderRegistration,
                    for: index)
                
            case TitleWithCategoryHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: recentHeaderRegistration,
                    for: index)
                
            default: return nil
            }
        }
    }
    
    override func configureNavigation() {
        
        let customLabel = UILabel()
        customLabel.designed(text: "청년톡톡", fontType: .g20Bold, textColor: .black)
        
        let customView = UIBarButtonItem(customView: customLabel)
        
        self.navigationItem.leftBarButtonItem = customView
        
        // #if DEBUG
        let commandButton = UIButton()
        commandButton.designed(title: "DEBUG", bgColor: .clear, fontType: .g14Bold)
        let commandItem = UIBarButtonItem(customView: commandButton)
        self.navigationItem.rightBarButtonItem = commandItem
        
        commandButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                owner.modalPresentationStyle = .formSheet
                owner.present(DebugViewController(), animated: true)
                
            }.disposed(by: disposeBag)
        
        // #endif
    }
    
    func update(section: HomeLayout, items: [HomeSectionItems]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        print("HomeViewController Deinit")
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let total = self.snapshot.itemIdentifiers(inSection: .recent).count
        let currentPage = (total / 10) + 1
        
        // 끝에서 5개의 아이템 이내일 경우 다음 페이지 로드 요청
        if let max = indexPaths.map({ $0.item }).max(), max >= total - 2 {
            viewModel.input.pageUpdate.accept(currentPage)
        }
    }
}
