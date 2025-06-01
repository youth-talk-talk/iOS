//
//  MyOrScrapPostViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 6/1/25.
//

import UIKit

enum MyOrScrapType {
    case myPost
    case scrapPost
    
    var isMyPost: Bool {
        self == .myPost
    }
}

final class MyOrScrapPostViewController: RootViewController {
    
    private let type: MyOrScrapType
    
    private var posts: [RPDTO] = []
    
    private let postCountLabel = UILabel().then {
        $0.designed(text: "게시글 개수", font: .p12Regular)
    }
    
    private lazy var postCollectionView = makeCollectionView(layout: postListLayout()).then {
        $0.register(cells: NewPostCell.self)
    }
    
    private lazy var emptyView = EmptyView(text: type.isMyPost ? "작성한 게시글이 없습니다." : "스크랩한 게시글이 없습니다.")
    
    init(type: MyOrScrapType) {
        self.type = type

        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(postCountLabel)
        view.addSubview(postCollectionView)
        view.addSubview(emptyView)
        
        backImageView.isHidden = true
        xImageView.isHidden = false
        
        postCountLabel.snp.makeConstraints {
            $0.top.equalTo(xImageView.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(postCountLabel.snp.bottom).offset(moderate(14))
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
        
        setMenuTitle(type.isMyPost ? "작성한 글" : "스크랩한 게시글")
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        Task {
            if type.isMyPost {
                let result = await APIManager().requestAPI(
                    router: PostRouter.fetchMyPost(page: 0),
                    type: ConditionReviewDTO.self)
                
                switch result {
                case .success(let post):
                    DispatchQueue.main.async {
                        self.posts = post.data.posts.map {
                            .init(postId: $0.postId,
                                  title: $0.title,
                                  content: $0.content,
                                  writerID: 0,
                                  scraps: $0.scraps,
                                  scrap: $0.scrap,
                                  comments: $0.comments,
                                  contentPreview: $0.content,
                                  policyId: $0.policyId,
                                  policyTitle: $0.policyTitle,
                                  category: "",
                                  createAt: "")
                        }
                        self.postCollectionView.reloadData()
                        self.emptyView.isHidden = !self.posts.isEmpty
                        self.postCountLabel.text = "개시글 \(self.posts.count)개"
                    }
                    
                case .failure:
                    break
                }

            } else {
                let result = await APIManager().requestAPI(
                    router: PostRouter.fetchScrapPost(query: .init(categories: [.all], page: 0, size: 20)),
                    type: ConditionReviewDTO.self)
                
                switch result {
                case .success(let post):
                    DispatchQueue.main.async {
                        self.posts = post.data.posts
                        self.postCollectionView.reloadData()
                        self.emptyView.isHidden = !self.posts.isEmpty
                        self.postCountLabel.text = "개시글 \(self.posts.count)개"
                    }
                    
                case .failure:
                    break
                }
            }
        }
    }
}

extension MyOrScrapPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: NewPostCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.setData(posts[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
