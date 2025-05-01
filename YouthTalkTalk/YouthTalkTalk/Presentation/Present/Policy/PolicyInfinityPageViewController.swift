//
//  PolicyInfinityPageViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

import UIKit

final class PolicyInfinityPageViewController: UIViewController {

    private let resultCountLabel = UILabel().then {
        $0.designed(text: "총 0건", font: .p14Regular)
    }
    
    // MARK: 최신순 정렬
    private let sortStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(2)
        $0.alignment = .center
    }
    
    private let sortLabel = UILabel().then {
        $0.designed(text: "최신순", font: .p14Regular)
    }
    
    private let sortArrowImageView = UIImageView(image: .arrowDown.withTintColor(.black))
    
    private let sortDropdownView = UIView().then {
        $0.setShadow()
        $0.layer.cornerRadius = moderate(6)
        $0.isHidden = true
    }
    
    private let newImageView = UIImageView(image: .checkGreen)
    private let newLabel = UILabel().then {
        $0.designed(text: "최신순", font: .p14Regular, textColor: .green)
    }
    
    private let popularImageView = UIImageView(image: .checkGreen.withTintColor(.white))
    private let popularLabel = UILabel().then {
        $0.designed(text: "인기순", font: .p14Regular, textColor: .gray90)
    }
    
    private let policyCellSize = CGSize(width: UIScreen.main.bounds.width - moderate(32),
                                        height: moderate(123))
    private lazy var policyCollectionView = makeCollectionView(policyCellSize, direction: .vertical).then {
        $0.register(cells: PolicyCell.self)
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortStackView.onTapped { [weak self] in
            self?.sortDropdownView.isHidden.toggle()
        }
        
        view.addSubview(resultCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(policyCollectionView)
        view.addSubview(sortDropdownView)

        sortStackView.addArrangedSubview(sortLabel)
        sortStackView.addArrangedSubview(sortArrowImageView)
        
        sortDropdownView.addSubviews(newLabel,
                                     newImageView,
                                     popularLabel,
                                     popularImageView)
        
        resultCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderate(10))
            $0.leading.equalToSuperview()
        }
        
        sortStackView.snp.makeConstraints {
            $0.centerY.equalTo(resultCountLabel)
            $0.trailing.equalToSuperview()
        }
        
        sortArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(16))
        }
        
        sortDropdownView.snp.makeConstraints {
            $0.top.equalTo(sortStackView.snp.bottom).offset(moderate(7))
            $0.trailing.equalTo(sortStackView)
            $0.width.equalTo(moderate(120))
            $0.height.equalTo(moderate(80))
        }
        
        newLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(moderate(10))
        }
        
        newImageView.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(moderate(10))
            $0.size.equalTo(20)
        }
        
        popularLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(moderate(10))
        }
        
        popularImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(moderate(10))
            $0.size.equalTo(20)
        }
        
        policyCollectionView.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom).offset(moderate(10))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func makeCollectionView(_ itemSize: CGSize, direction: UICollectionView.ScrollDirection = .horizontal) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = direction
            layout.itemSize = itemSize

            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
        }
        
        return collectionView
    }
}

extension PolicyInfinityPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
        
        cell.setStyle(.border)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return moderate(16)
    }
}
