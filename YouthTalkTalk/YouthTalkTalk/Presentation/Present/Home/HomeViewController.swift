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
    case topFive(PolicyEntity)
    case all(PolicyEntity)
    
    var data: PolicyEntity? {
        switch self {
        case .category:
            return nil
        case .topFive(let policyEntity):
            return policyEntity
        case .all(let policyEntity):
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
        
        viewModel.output.topFivePoliciesRelay
            .bind(with: self) { owner, topFivePolicies in
                
                owner.update(section: .popular, items: topFivePolicies)
                
            }.disposed(by: disposeBag)
        
        viewModel.output.allPoliciesRelay
            .bind(with: self) { owner, allPolicies in
                
                owner.update(section: .recent, items: allPolicies)
                
            }.disposed(by: disposeBag)
        
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
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier.data)
        }
        
        // 최근 업데이트 Section
        let recentSectionRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, HomeSectionItems> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier.data)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) {  [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self else { return nil }
            guard let section = HomeLayout(rawValue: indexPath.section) else { return nil }
            
            if section == .category { return nil }
            
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
        let categoryHeaderRegistration = UICollectionView.SupplementaryRegistration<CategoryButtonHeaderView>(elementKind: CategoryButtonHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            supplementaryView.prepareForReuse()
            
            guard let self else { return }
            
            let tapGesture = UITapGestureRecognizer()
            supplementaryView.transparentView.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let viewModel = SearchViewModel()
                    
                    let nextVC = SearchViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }.disposed(by: disposeBag)
        }
        
        // 인기정책 Header Registration
        let popularHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { supplementaryView, elementKind, indexPath in
            
            // guard let section = HomeLayout(rawValue: indexPath.section) else { return }
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
        
        let count = viewModel.allPoliciesCount()
        
        // 카테고리 변경 시에는 기존 데이터 모두 삭제 후 새로 등록
        // 변경 필요
        if count == 10 {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        }
            
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    deinit {
        print("HomeViewController Deinit")
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let total = viewModel.allPoliciesCount()
        let currentPage = (total / 10) + 1
        
        indexPaths.forEach { indexPath in
            let currentPosition = indexPath.item
            
            // 끝에서 5개의 아이템 이내일 경우 다음 페이지 로드 요청
            if currentPosition >= total - 5 {
                viewModel.input.updateRecentPolicies.accept(currentPage)
            }
        }
    }
}
