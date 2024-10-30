//
//  MyPageViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/29/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class MyPageViewController: RootViewController {
    
    enum FavoriteList: String, CaseIterable {
        case scrapPolicy = "스크랩한 정책"
        case scrapPost = "스크랩한 게시물"
        case myPost = "작성한 게시물"
        case myComment = "작성한 댓글"
        case likeComment = "좋아요한 댓글"
    }
    
    enum MyPageItemType: Hashable {
        case policy(PolicyEntity)
        case favorite(String)
    }
    
    private var viewModel: MyPageInterface
    private var dataSource: UICollectionViewDiffableDataSource<MyPageSection, MyPageItemType>!
    private var snapshot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageItemType>()
    
    let nicknameLabel = UILabel()
    let settingButton = UIButton()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MyPageSection.layout())
    
    init(viewModel: MyPageInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if !snapshot.itemIdentifiers(inSection: .policy).isEmpty {
         
            let items = snapshot.itemIdentifiers(inSection: .policy)
            self.snapshot.deleteItems(items)
            self.dataSource.apply(snapshot)
        }
        
        viewModel.input.fetchUpcomingScrapEvent.accept(())
    }
    
    override func configureView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        snapshot.appendSections([.policy, .favorite])
        
        view.backgroundColor = .white
        flexView.backgroundColor = .white
        
        nicknameLabel.designed(text: "abc", fontType: .p18Bold, textColor: .black)
        settingButton.designWithImage(title: "계정 관리", image: UIImage.setting, bgColor: .clear, titleColor: .black, fontType: .p14Regular)
        
        settingButton.layer.cornerRadius = 18
        settingButton.layer.masksToBounds = true
        settingButton.layer.borderColor = UIColor.gray30.cgColor
        settingButton.layer.borderWidth = 1
        
        let recentCellRegistration = UICollectionView.CellRegistration<RecentCollectionViewCell, PolicyEntity> { cell, indexPath, itemIdentifier in
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.configure(data: itemIdentifier)
            
            let data = itemIdentifier.policyId
            
            cell.scrapButton.rx.tap
                .bind(with: self) { owner, _ in
                    
                    owner.viewModel.input.updatePolicyScrap.accept(data)
                }
                .disposed(by: cell.disposeBag)
            
            cell.tapGesture.rx.event
                .bind(with: self) { owner, _ in
                    
                    let repository = PolicyRepositoryImpl()
                    let useCase = PolicyUseCaseImpl(policyRepository: repository)
                    let viewModel = PolicyViewModel(policyID: itemIdentifier.policyId, policyUseCase: useCase)
                    let nextVC = PolicyViewController(viewModel: viewModel)
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        
        let favoriteCellRegistration = UICollectionView.CellRegistration<FavoriteCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            
            cell.configure(title: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>(elementKind: TitleHeaderView.identifier) {
            supplementaryView, elementKind, indexPath in
            
            guard let section = MyPageSection(rawValue: indexPath.section) else { return }
            
            supplementaryView.setTitle(section.title)
        }
        
        dataSource = UICollectionViewDiffableDataSource<MyPageSection, MyPageItemType>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .policy(let policyEntity):
                return collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: policyEntity)
            case .favorite(let title):
                return collectionView.dequeueConfiguredReusableCell(using: favoriteCellRegistration, for: indexPath, item: title)
            }
        }
        
        dataSource.supplementaryViewProvider = { view, kind, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    override func configureLayout() {
        
        flexView.flex.define { flex in
            
            flex.addItem().define { row in
                
                row.addItem(nicknameLabel)
                    .alignSelf(.center)
                
                row.addItem(settingButton)
                    .width(115)
                    .height(36)
                    .alignSelf(.center)
            }
            .direction(.row)
            .marginHorizontal(17)
            .justifyContent(.spaceBetween)
            .height(100)
            
            flex.addItem(collectionView)
                .width(100%)
                .grow(1)
        }
    }
    
    override func bind() {
        
        let items = FavoriteList.allCases.map { MyPageItemType.favorite($0.rawValue) }
        
        update(section: .favorite, items: items)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                let sectionType = MyPageSection(rawValue: indexPath.section) ?? .policy
                let items = owner.snapshot.itemIdentifiers(inSection: sectionType)
                let item = items[indexPath.item]
                
                switch item {
                case .policy(let policyEntity):
                    print(policyEntity)
                case .favorite(let title):
                    
                    let useCase = PolicyUseCaseImpl(policyRepository: PolicyRepositoryImpl())
                    let viewModel = MyScrapViewModel(useCase: useCase)
                    let vc = MyScrapViewController(viewModel: viewModel)
                    
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 마감일 임박 리스트 호출
        viewModel.output.upcomingScrapPolicies
            .bind(with: self) { owner, upcomingEntities in
                
                let items = upcomingEntities.map { MyPageItemType.policy($0) }
                
                owner.update(section: .policy, items: items)
            }
            .disposed(by: disposeBag)
        
        // 스크랩 취소
        viewModel.output.canceledScrapEntity
            .bind(with: self) { owner, scrapEntity in
                
                let policyItems = owner.snapshot.itemIdentifiers(inSection: .policy)
                    .compactMap { item in
                        switch item {
                        case .policy(let policyEntity):
                            return policyEntity
                        case .favorite:
                            return nil
                        }
                    }
                
                guard let item = policyItems.filter({ $0.policyId == scrapEntity.id }).first else { return }
                
                let pageItemType = MyPageItemType.policy(item)
                
                owner.delete(item: pageItemType)
                
            }
            .disposed(by: disposeBag)
    }
}


extension MyPageViewController {
    
    func update(section: MyPageSection, items: [MyPageItemType]) {
        
        snapshot.appendItems(items, toSection: section)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func delete(item: MyPageItemType) {
        
        snapshot.deleteItems([item])
        
        self.dataSource.apply(snapshot)
    }
}
