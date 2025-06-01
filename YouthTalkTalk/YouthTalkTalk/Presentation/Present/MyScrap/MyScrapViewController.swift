//
//  MyScrapViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import UIKit

final class MyScrapViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.designed(text: "스크랩 한 정책", font: .p18Semi)
    }
    
    private let xImageView = UIImageView(image: .littleXmark)
    
    private lazy var scrapCollectionView = makeCollectionView(cellSize).then {
        $0.register(cells: PolicyCell.self)
    }
    
    private let cellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32),
                                  height: moderate(123))
    
    private let emptyView = EmptyView(text: "아직 스크랩한 정책이 없습니다.")
    
    private func makeCollectionView(_ itemSize: CGSize, direction: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = direction
            layout.itemSize = itemSize

            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.contentInset.left = 16
            $0.contentInset.right = 16
            $0.contentInset.bottom = 16
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        return collectionView
    }
    
    private var scrapPolicies: [PolicyDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let result = await APIManager().requestAPI(
                router: PolicyRouter.fetchScrapPolicy,
                type: ScrapPolicyDTO.self)
            switch result {
            case .success(let scrap):
                scrapPolicies = scrap.data
                scrapCollectionView.reloadData()
                
            case .failure:
                break
            }
        }
        
        view.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = true
        
        xImageView.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubviews([titleLabel,
                          xImageView,
                          scrapCollectionView,
                          emptyView])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(moderate(24))
        }
        
        xImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
            $0.size.equalTo(moderate(24))
        }
        
        scrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(29))
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension MyScrapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyView.isHidden = !scrapPolicies.isEmpty
        
        return scrapPolicies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.setStyle(.border)
        cell.setData(scrapPolicies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return moderate(16)
    }
}

