//
//  RegionBottomSheetViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 4/9/25.
//

import UIKit

final class RegionBottomSheetViewController: RootViewController {
    
    private let regions = ["전체 지역", "서울", "부산", "대구", "인천", "광주",
                           "대전", "울산", "경기", "강원", "충북", "충남",
                           "전북", "전남", "경북", "경남", "제주", "세종"]
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "지역을 선택해 주세요.", font: .p18Semi)
    }
    
    private let grabView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 2
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColumnLayout()).then {
        $0.backgroundColor = .white
        $0.register(RegionCell.self, forCellWithReuseIdentifier: "RegionCell")
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
    }
    
    private var selectedRegion: String? {
        didSet {
            applyButton.isEnabled = selectedRegion != nil
        }
    }
    
    private let applyButton = UIButton().then {
        $0.designed(title: "적용하기")
        $0.isEnabled = false
    }
    
    private let onRegionTapped: (String?) -> Void
    
    init(onRegionTapped: @escaping (String?) -> Void) {
        self.onRegionTapped = onRegionTapped
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyButton.onTapped { [weak self] in
            self?.onRegionTapped(self?.selectedRegion)
            self?.dismiss(animated: true)
        }
        
        view.addSubview(grabView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(applyButton)
        
        grabView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grabView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(applyButton.snp.top).offset(-26)
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(46)
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension RegionBottomSheetViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as? RegionCell else {
            return UICollectionViewCell()
        }
        let region = regions[indexPath.item]
        cell.configure(with: region, isSelected: region == selectedRegion)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = regions[indexPath.item]
        selectedRegion = selected

        collectionView.reloadData()
    }
    
    func createThreeColumnLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
