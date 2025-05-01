//
//  DetailFilterViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class DetailFilterViewController: UIViewController {
    
    private let filterTitle: String
    private let subCategories: [String]
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(DetailFilterCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    init(filterTitle: String) {
        self.filterTitle = filterTitle
        self.subCategories = ["카", "카테", "카테고리", "수", "테", "테고리테리", "카테", "카테고리", "수", "테", "테고리테리"]
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension DetailFilterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell", for: indexPath
        ) as? DetailFilterCell else { return .zero }

        return cell.adjustCellSize(height: 32, label: subCategories[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DetailFilterCell else { return UICollectionViewCell() }

        cell.label.text = subCategories[indexPath.row]
        
        return cell
    }
}

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
