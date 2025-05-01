//
//  SettingRegionViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 2/3/25.
//

import UIKit

final class SettingRegionViewController: UIViewController {
    private let completeChangedMeData: (PatchMeDataDTO) -> Void
    
    private let viewModel = SettingViewModel()
    
    private let titleLabel = UILabel().then {
        $0.designed(text: "지역설정", font: .g20Bold, textColor: .gray60)
    }
    
    private let closeButton = UIButton().then {
        $0.designedByImage(UIImage.closeCircle)
    }
    
    private let noticeLabel = UILabel().then {
        $0.designed(text: "지역설정은 모든 카테고리에 적용됩니다",
                    font: .p16Regular16,
                    textColor: .gray60)
        $0.backgroundColor = .gray10
        $0.textAlignment = .center
    }
    
    private let searchImageView = UIImageView(image: UIImage.magnifyingglass)
    
    private let selectRegionLabel = UILabel().then {
        $0.designed(text: "지역선택", font: .p18Bold)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: collectionViewLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(SettingRegionCell.self, forCellWithReuseIdentifier: "region")
        $0.backgroundColor = .clear
    }
    
    private let applyButton = UIButton().then {
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = FontManager.font(.p16Regular16)
        $0.backgroundColor = .gray20
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    init(completeChangedMeData: @escaping (PatchMeDataDTO) -> Void) {
        self.completeChangedMeData = completeChangedMeData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        viewModel.onSavedInfo = { [weak self] patchData in
            self?.completeChangedMeData(patchData)
            self?.dismiss(animated: true)
        }
        
        closeButton.onTapped { [weak self] in
            self?.dismiss(animated: true)
        }
        
        applyButton.onTapped { [weak self] in
            self?.viewModel.saveChangedInfo()
        }
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(noticeLabel)
        view.addSubview(searchImageView)
        view.addSubview(selectRegionLabel)
        view.addSubview(collectionView)
        view.addSubview(applyButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(19)
            $0.top.equalTo(titleLabel)
            $0.size.equalTo(24)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(noticeLabel.snp.bottom).offset(20)
            $0.size.equalTo(24)
        }
        
        selectRegionLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchImageView)
            $0.leading.equalTo(searchImageView.snp.trailing).offset(4)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchImageView.snp.bottom).offset(12)
            $0.height.equalTo(469)
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(50)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let insets = UIScreen.main.bounds.width * 0.05
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2),
                                              heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(11)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: insets, bottom: 24, trailing: insets)
        
        return UICollectionViewCompositionalLayout { _, _ in section }
    }
}

extension SettingRegionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PolicyLocationKR.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "region", for: indexPath) as? SettingRegionCell,
              let region = PolicyLocationKR(rawValue: indexPath.item) else { return UICollectionViewCell() }
        
        if let selectedRegion = viewModel.selectedNewRegion, selectedRegion == region {
            cell.contentView.backgroundColor = .lime40
            cell.contentView.layer.borderWidth = 0
            
        } else {
            cell.contentView.backgroundColor = .clear
            cell.contentView.layer.borderWidth = 1
        }
        
        cell.title.text = region.displayName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let region = PolicyLocationKR(rawValue: indexPath.item),
              region != viewModel.selectedNewRegion else { return }
        
        viewModel.selectedNewRegion = region
        applyButton.backgroundColor = .lime40
        collectionView.reloadData()
    }
}
