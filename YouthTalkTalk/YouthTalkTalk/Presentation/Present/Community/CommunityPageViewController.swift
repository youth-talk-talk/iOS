//
//  CommunityPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class CommunityPageViewController: UIViewController {
    
    private let baseScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let containerView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "🔥 인기 후기 게시물", font: .p16SemiBold)
    }
    
    private let popularPostCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(122), height: moderate(155))
    private lazy var popularPostCollectionView = makeCollectionView(popularPostCellSize).then {
        $0.register(cells: PopularPostCell.self)
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private let filters = ["전체", "주거", "교육", "일자리", "복지", "참여"]

    private lazy var filterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: NewCategoryCell.self)
    }
    
    private let postCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32), height: moderate(186))
    private lazy var postCollectionView = makeCollectionView(postCellSize, direction: .vertical).then {
        $0.register(cells: NewPostCell.self)
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(containerView)
        
        containerView.addSubviews(titleLabel,
                                  popularPostCollectionView,
                                  dividerView,
                                  filterCollectionView,
                                  postCollectionView)
        
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
            $0.top.equalTo(filterCollectionView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1000)
            $0.bottom.equalToSuperview().inset(moderate(30))
        }
    }
    
    private func makeCollectionView(_ itemSize: CGSize, direction: UICollectionView.ScrollDirection = .horizontal) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = direction
            layout.minimumLineSpacing = moderate(20)
            layout.itemSize = itemSize

            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.contentInset.left = moderate(16)
            $0.contentInset.right = moderate(16)
            $0.showsHorizontalScrollIndicator = false
        }
        
        return collectionView
    }
}

extension CommunityPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return filters.count
            
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            guard let cell: NewCategoryCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.label.text = filters[indexPath.row]
            
            return cell
            
        } else if collectionView == postCollectionView {
            guard let cell: NewPostCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            return cell
            
        } else {
            guard let cell: PopularPostCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
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
}
