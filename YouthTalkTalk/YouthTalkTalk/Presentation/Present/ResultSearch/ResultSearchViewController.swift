//
//  ResultSearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout

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
    
    let type: PolicyCategory?
    
    init(viewModel: ResultSearchInterface, type: PolicyCategory? = nil) {
        self.viewModel = viewModel
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView.collectionView.prefetchDataSource = self
        
        cellRegistration()
        headerRegistration()
    }
    
    override func configureNavigation() {
        
        if let type { self.updateNavigationBackButtonTitle(title: type.name) }
    }
    
    override func bind() {
        
//        snapshot.appendSections([.condition, .result])
//        
//        self.viewModel.output.searchListRelay
//            .bind(with: self) { owner, items in
//                owner.update(section: .result, items: items)
//            }
//            .disposed(by: disposeBag)
//        
//        self.viewModel.fetchSearchList.accept(())
    }
    
    //MARK: Cell Registration
    private func cellRegistration() {
//        
//        // 인기정책 Section
//        let resultSectionRegistration = UICollectionView.CellRegistration<PostListCollectionViewCell, ResultSearchSectionItems> { [weak self] cell, indexPath, itemIdentifier in
//            
//            guard let self else { return }
//            
//            cell.layer.cornerRadius = 10
//            cell.layer.masksToBounds = true
//            
//            // 셀 클릭
//            cell.tapGesture.rx.event
//                .bind(with: self) { owner, _ in
//                    
//                    switch itemIdentifier {
//                        
//                        // 검색 결과 페이지에서 정책 탭할시 정책 상세로 이동
//                    case .resultPolicy(let policyEntity):
//                        let repository = PolicyRepositoryImpl()
//                        let useCase = PolicyUseCaseImpl(policyRepository: repository)
//                        let viewModel = PolicyViewModel(policyID: policyEntity.policyId, policyUseCase: useCase)
//                        let nextVC = PolicyViewController(viewModel: viewModel)
//                        
//                        owner.navigationController?.pushViewController(nextVC, animated: true)
//                        
//                        // 검색 결과 페이지에서 게시글 탭할시 게시글 상세로 이동
//                    case .resultRP(let rpEntity):
//                        let repository = ReviewRepositoryImpl()
//                        let commentRepository = CommentRepositoryImpl()
//                        let useCase = ReviewUseCaseImpl(reviewRepository: repository)
//                        let commentUseCase = CommentUseCaseImpl(commentRepository: commentRepository)
//                        let viewModel = PosetDetailViewModel(data: rpEntity, useCase: useCase, commnetUseCase: commentUseCase)
//                        let resultDetailVC = PostDetailViewController(viewModel: viewModel)
//                        // 게시글 상세에서 신고할 시 검색 결과에서 사라지는 동작 필요할 시 주석 해제
//                        // resultDetailVC.delegate = self
//                        
//                        owner.navigationController?.pushViewController(resultDetailVC, animated: true)
//                        
//                    default:
//                        break
//                    }
//                }
//                .disposed(by: cell.disposeBag)
//            
//            // 스크랩
//            cell.scrapButton.rx.tap
//                .bind(with: self) { owner, _ in
//                    
//                    switch itemIdentifier {
//                        
//                    case .resultPolicy(let policyEntity):
//                        
//                        owner.viewModel.input.updatePostScrap.accept("\(policyEntity.policyId)")
//                        
//                    case .resultRP(let rpEntity):
//                        
//                        guard let postId = rpEntity.postId else { return }
//                        
//                        owner.viewModel.input.updatePostScrap.accept(String(postId))
//                        
//                    default:
//                        break
//                    }
//                }
//                .disposed(by: cell.disposeBag)
//            
//            switch itemIdentifier {
//                
//            case .resultPolicy(let policyEntity):
//                
//                // cell에 적용(스크롤시에도 유지)
//                if let scrap = viewModel.output.scrapStatus["\(policyEntity.policyId)"] {
//                    cell.updateScrapStatus(scrap, 0)
//                }
//                
//                // cell에 즉시 적용
//                viewModel.output.scrapStatusRelay
//                    .bind(with: self) { owner, scrapStatus in
//                        if let scrap = scrapStatus[policyEntity.policyId] {
//                            cell.updateScrapStatus(scrap, 0)
//                        }
//                    }
//                    .disposed(by: self.disposeBag)
//                
//            case .resultRP(let rpEntity):
//                
//                guard let id = rpEntity.postId else { return }
//                
//                if let scrap = viewModel.output.scrapStatus[String(id)] {
//                    cell.updateScrapStatus(scrap, 0)
//                }
//                
//                viewModel.output.scrapStatusRelay
//                    .bind(with: self) { owner, scrapStatus in
//                        
//                        if let scrap = scrapStatus[String(id)] {
//                            cell.updateScrapStatus(scrap, 0)
//                        }
//                    }
//                    .disposed(by: disposeBag)
//                break
//                
//            default:
//                break
//            }
//            
//            
//            if let policy = itemIdentifier.policy {
//                cell.configure(data: policy)
//            }
//            
//            if let rp = itemIdentifier.rp {
//                cell.configure(data: rp)
//            }
//        }
//        
//        dataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.collectionView) { collectionView, indexPath, itemIdentifier in
//            
//            guard let section = ResultSearchLayout(rawValue: indexPath.section) else { return nil }
//            
//            if section == .result {
//                
//                let cell = collectionView.dequeueConfiguredReusableCell(using: resultSectionRegistration, for: indexPath, item: itemIdentifier)
//                
//                return cell
//            }
//            
//            return nil
//        }
    }
    
    //MARK: Header Registration
    private func headerRegistration() {
        
        // 조건선택 Header Registration
        let conditionHeaderRegistration = UICollectionView.SupplementaryRegistration<DetailConditionHeaderView>(elementKind: DetailConditionHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            supplementaryView.tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let nextVC = DetailConditionViewController()
                    
                    nextVC.viewModel.result = { age, codeList, isFinished in
                        let items = owner.snapshot.itemIdentifiers(inSection: .result)
                        owner.snapshot.deleteItems(items)
                        
                        owner.viewModel.updateData(age: age, employment: codeList, isFinished: isFinished)
                    }
                    
                    let navigationController = UINavigationController(rootViewController: nextVC)
                    
                    owner.present(navigationController, animated: true)
                }
                .disposed(by: disposeBag)
        }
        
        // 검색결과 Header Registration
        let resultHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            self.viewModel.output.totalCountRelay
                .bind(with: self) { owner, totalCount in
                    var text = "건의 정책이 있어요"
                    if owner.viewModel is ResultReviewViewModel { text = "건의 후기가 있어요" }
                    if owner.viewModel is ResultPostViewModel { text = "건의 게시글이 있어요" }

                    supplementaryView.setTitle("총 \(totalCount)\(text)")
                }
                .disposed(by: supplementaryView.disposeBag)
        }
        
        let resultFooterRegistration = UICollectionView.SupplementaryRegistration<DefaultFooterView>(elementKind: DefaultFooterView.identifier) { supplementaryView, elementKind, indexPath in
            
            
        }
        
        // Header 등록
        dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
            
            guard let self else { return nil }
            
            switch kind {
                
            case DetailConditionHeaderView.identifier:
                
                let view = self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: conditionHeaderRegistration,
                    for: index)
                
                let type = viewModel.searchType
                
                if type != .policy {
                    view.hidden()
                }
                
                return view
                
            case TitleHeaderView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: resultHeaderRegistration,
                    for: index)
                
            case DefaultFooterView.identifier:
                
                return self.layoutView.collectionView.dequeueConfiguredReusableSupplementary(
                    using: resultFooterRegistration,
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

extension ResultSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let total = self.snapshot.itemIdentifiers(inSection: .result).count
        let currentPage = (total / 10)
        
        // 끝에서 5개의 아이템 이내일 경우 다음 페이지 로드 요청
        if let max = indexPaths.map({ $0.item }).max(), max >= total - 2 {
            viewModel.input.pageUpdate.accept(currentPage)
        }
    }
}
