//
//  CommunityPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit
import SnapKit

final class CommunityPageViewController: UIViewController {
    
    private var hotPosts: [RPDTO] = []
    private var posts: [RPDTO] = []
    
    var onReloadByCategory: ((PolicyCategory) -> Void)?
    
    private let baseScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let containerView = UIView()
    
    private var postCollectionViewTopConstraint: Constraint?
    
    private let titleLabel = UILabel().then {
        $0.designed(font: .p16SemiBold)
    }
    
    private lazy var popularPostCollectionView = makeCollectionView(layout: popularLayout()).then {
        $0.register(cells: PopularPostCell.self)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let filters: [PolicyCategory] = PolicyCategory.allCases

    private lazy var filterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: NewCategoryCell.self)
    }
    
    private lazy var postCollectionView = makeCollectionView(layout: postListLayout()).then {
        $0.register(cells: NewPostCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(containerView)
        
        containerView.addSubviews(titleLabel,
                                  popularPostCollectionView,
                                  dividerView,
                                  postCollectionView,
                                  filterCollectionView)
        
        baseScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderate(20))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        popularPostCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(180))
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(popularPostCollectionView.snp.bottom).offset(moderate(6))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(10))
        }
        
        filterCollectionView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(32))
        }
        
        postCollectionView.snp.makeConstraints {
            postCollectionViewTopConstraint = $0.top.equalTo(dividerView.snp.bottom).constraint
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(400)
        }
    }
    
    func reloadData(hotPosts: [RPDTO], posts: [RPDTO], type: communityType) {
        self.hotPosts = hotPosts
        self.posts = posts
        
        popularPostCollectionView.reloadData()
        postCollectionView.reloadData()
        
        filterCollectionView.isHidden = type == .free
        titleLabel.text = type == .free ? "🔥 인기 자유 게시물" : "🔥 인기 후기 게시물"
        
        if type == .free {
            postCollectionViewTopConstraint?.update(offset: 0)
        } else {
            postCollectionViewTopConstraint?.update(offset: moderate(20) + moderate(32))
        }
    }
    
    private func makeCollectionView(layout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        return collectionView
    }
    
    private func postListLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - moderate(32)),
                                                  heightDimension: .estimated(moderate(165)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - moderate(32)),
                                                   heightDimension: .estimated(moderate(165)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: moderate(8), leading: moderate(16), bottom: 0, trailing: moderate(16))

            return section
        }
        
        return layout
    }
    
    private func popularLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - moderate(122)),
                                                  heightDimension: .estimated(moderate(155)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - moderate(122)),
                                                   heightDimension: .estimated(moderate(155)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: moderate(8), leading: moderate(16), bottom: 0, trailing: moderate(16))
            
            return section
        }
        
        return layout
    }
}

extension CommunityPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return filters.count
            
        } else if collectionView == popularPostCollectionView {
            return hotPosts.count
            
        } else if collectionView == postCollectionView {
            return posts.count
            
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            guard let cell: NewCategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.label.text = filters[indexPath.row].name
            
            if indexPath.row == 0 {
                cell.changeColor(isGreen: true)
            }
            
            return cell
            
        } else if collectionView == postCollectionView {
            guard let cell: NewPostCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.setData(posts[indexPath.row])
            
            return cell
            
        } else {
            guard let cell: PopularPostCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.setData(hotPosts[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == filterCollectionView {
            return moderate(12)
            
        } else {
            return moderate(16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            for i in 0..<filters.count {
                let cellIndexPath = IndexPath(item: i, section: 0)
                if let cell = collectionView.cellForItem(at: cellIndexPath) as? NewCategoryCell {
                    cell.changeColor(isGreen: i == indexPath.item)
                    
                    if i == indexPath.item {
                        onReloadByCategory?(filters[i])
                    }
                }
            }
        }
    }
}
