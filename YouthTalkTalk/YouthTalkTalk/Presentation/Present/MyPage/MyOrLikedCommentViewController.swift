//
//  MyOrLikedCommentViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 6/1/25.
//

import UIKit

enum MyOrLikedType {
    case myComment
    case likedComment
    
    var isMyComment: Bool {
        self == .myComment
    }
}

final class MyOrLikedCommentViewController: RootViewController {
    
    private let type: MyOrLikedType
    
    private var comments: [LikedCommentData] = []
    
    private let countLabel = UILabel().then {
        $0.designed(font: .p12Regular)
    }
    
    private lazy var commentCollectionView = makeCollectionView(layout: postListLayout()).then {
        $0.register(cells: NewPostCell.self)
    }
    
    private lazy var emptyView = EmptyView(text: type.isMyComment ? "작성한 댓글이 없습니다." : "좋아요한 댓글이 없습니다.")
    
    init(type: MyOrLikedType) {
        self.type = type

        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(countLabel)
        view.addSubview(commentCollectionView)
        view.addSubview(emptyView)
        
        backImageView.isHidden = true
        xImageView.isHidden = false
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(xImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        commentCollectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuTitle(type.isMyComment ? "내 댓글" : "좋아요한 댓글")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        Task {
            if type.isMyComment {
                let result = await APIManager().requestAPI(
                    router: PostRouter.fetchMyComment,
                    type: LikedComment.self)
                
                switch result {
                case .success(let comments):
                    self.countLabel.text = "댓글 \(String(comments.data?.comments.count ?? 0))개"
                    self.emptyView.isHidden = !((comments.data?.comments ?? []).isEmpty)
                    self.comments = comments.data?.comments ?? []
                case .failure:
                    break
                }

            } else {
                let result = await APIManager().requestAPI(
                    router: PostRouter.fetchLikedComment,
                    type: LikedComment.self)
                
                switch result {
                case .success(let comments):
                    self.countLabel.text = "댓글 \(String(comments.data?.comments.count ?? 0))개"
                    self.emptyView.isHidden = !((comments.data?.comments ?? []).isEmpty)
                    self.comments = comments.data?.comments ?? []
                    
                case .failure:
                    break
                }
            }
        }
    }
}

extension MyOrLikedCommentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: NewCommentCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.setData(comments[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 게시글 상세 이동
    }
}
