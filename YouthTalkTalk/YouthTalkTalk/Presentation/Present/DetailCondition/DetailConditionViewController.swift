//
//  DetailConditionViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout

enum DetailConditionKind: Int {
    
    case age
    case employment
    case deadline
    
    var kind: String {
        switch self {
        case .age:
            return "age"
        case .employment:
            return "employment"
        case .deadline:
            return "deadline"
        }
    }
    
    var title: String {
        switch self {
        case .age:
            return "연령"
        case .employment:
            return "취업상태"
        case .deadline:
            return "마감여부"
        }
    }
}
enum DeadlineStatus: Int, CaseIterable {
    case all
    case inProgress
    case closed
    
    var title: String {
        switch self {
        case .all:
            return "전체 선택"
        case .inProgress:
            return "진행중인 정책"
        case .closed:
            return "종료된 정책"
        }
    }
    
    var status: Bool? {
        switch self {
        case .all:
            return nil
        case .inProgress:
            return true
        case .closed:
            return false
        }
    }
}
enum EmploymentStatus: Int, CaseIterable {
    case all
    case employee
    case selfEmployed
    case unemployed
    case freelancer
    case dayLaborer
    case preEntrepreneur
    case shortTermWorker
    case farming
    case noRestriction
    case other
    
    var title: String {
        switch self {
        case .all:
            return "전체 선택"
        case .employee:
            return "재직자"
        case .selfEmployed:
            return "자영업자"
        case .unemployed:
            return "미취업자"
        case .freelancer:
            return "프리랜서"
        case .dayLaborer:
            return "일용근로자"
        case .preEntrepreneur:
            return "예비창업자"
        case .shortTermWorker:
            return "단기근로자"
        case .farming:
            return "영농종사자"
        case .noRestriction:
            return "제한없음"
        case .other:
            return "기타"
        }
    }
    
    var code: String {
        switch self {
        case .all:
            return ""
        case .employee:
            return "EMPLOYED"
        case .selfEmployed:
            return "SELF_EMPLOYED"
        case .unemployed:
            return "UNEMPLOYED"
        case .freelancer:
            return "FREELANCER"
        case .dayLaborer:
            return "DAILY_WORKER"
        case .preEntrepreneur:
            return "ENTREPRENEUR"
        case .shortTermWorker:
            return "TEMPORARY_WORKER"
        case .farming:
            return "FARMER"
        case .noRestriction:
            return "NO_RESTRICTION"
        case .other:
            return "OTHER"
        }
    }
}

class DetailConditionViewController: BaseViewController<DetailConditionView> {
    
    let viewModel = DetailConditionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigation() {
        
        let customTitleLabel = UILabel()
        customTitleLabel.text = "상세조건"
        customTitleLabel.font = FontManager.font(.g20Bold)
        self.navigationItem.titleView = customTitleLabel
        
        let cancelButton = UIBarButtonItem(image: .xmark, style: .done, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = cancelButton
        
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureCollectionView() {
        
        layoutView.collectionView.dataSource = self
        layoutView.collectionView.delegate = self
        
        layoutView.collectionView.register(TitleWithImageHeaderView.self, forSupplementaryViewOfKind: DetailConditionKind.age.kind, withReuseIdentifier: TitleWithImageHeaderView.identifier)
        layoutView.collectionView.register(TitleWithImageHeaderView.self, forSupplementaryViewOfKind: DetailConditionKind.employment.kind, withReuseIdentifier: TitleWithImageHeaderView.identifier)
        layoutView.collectionView.register(TitleWithImageHeaderView.self, forSupplementaryViewOfKind: DetailConditionKind.deadline.kind, withReuseIdentifier: TitleWithImageHeaderView.identifier)
        layoutView.collectionView.register(AgeCollectionViewCell.self, forCellWithReuseIdentifier: "age")
        layoutView.collectionView.register(ChoiceCollectionViewCell.self, forCellWithReuseIdentifier: "employment")
        layoutView.collectionView.register(ChoiceCollectionViewCell.self, forCellWithReuseIdentifier: "deadline")
    }
    
    override func bind() {
        
        layoutView.applyButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.viewModel.applyTapEvent.accept(())
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.isButtonEnabled
            .bind(to: layoutView.applyButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.selectedIndexEvent
            .bind(with: self) { owner, _ in
                
                owner.layoutView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
}

extension DetailConditionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let layout = DetailConditionLayout(rawValue: section) else {
            return 0
        }
        
        return layout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let kind = DetailConditionKind.init(rawValue: indexPath.section),
              let header = layoutView.collectionView.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: TitleWithImageHeaderView.identifier, for: indexPath) as? TitleWithImageHeaderView else { return UICollectionReusableView() }
        
        header.setTitle(kind.title)
        
       return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let layout = DetailConditionLayout(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch layout {
        case .age:
            
            guard let cell = layoutView.collectionView.dequeueReusableCell(withReuseIdentifier: "age", for: indexPath) as? AgeCollectionViewCell else { return UICollectionViewCell() }
            
            cell.ageTextField.rx.text.orEmpty
                .bind(to: viewModel.ageInputEvent)
                .disposed(by: disposeBag)
            
            return cell
            
        case .employmentStatus:
            
            guard let cell = layoutView.collectionView.dequeueReusableCell(withReuseIdentifier: "employment", for: indexPath) as? ChoiceCollectionViewCell,
                  let status = EmploymentStatus(rawValue: indexPath.item) else { return UICollectionViewCell() }
            
            cell.mainButton.rx.tap
                .map { return indexPath }
                .bind(to: viewModel.selectedIndex)
                .disposed(by: cell.disposeBag)
            
            cell.mainButton.designed(title: status.title, titleColor: .black, bgColor: .clear, fontType: .p16Regular16, withAction: true)
            cell.mainButton.layer.borderWidth = 1
            
            let employmentStatus = viewModel.selectedStatus
            
            if let curStatus = EmploymentStatus(rawValue: indexPath.item),
               employmentStatus.contains(curStatus) {
            
                cell.mainButton.designed(title: status.title, titleColor: .black, bgColor: .lime40, fontType: .p16Regular16, withAction: true)
                cell.mainButton.layer.borderWidth = 0
            }
            
            return cell
            
        case .deadlineStatus:
            
            guard let cell = layoutView.collectionView.dequeueReusableCell(withReuseIdentifier: "deadline", for: indexPath) as? ChoiceCollectionViewCell,
                  let status = DeadlineStatus(rawValue: indexPath.item) else { return UICollectionViewCell() }
            
            cell.mainButton.rx.tap
                .map { return indexPath }
                .bind(to: viewModel.selectedDeadlineIndex)
                .disposed(by: cell.disposeBag)
            
            cell.mainButton.designed(title: status.title, titleColor: .black, bgColor: .clear, fontType: .p16Regular16, withAction: true)
            cell.mainButton.layer.borderWidth = 1
            
            let deadlineStatus = viewModel.selectedDeadlineStatus
            
            if deadlineStatus == status {
            
                cell.mainButton.designed(title: status.title, titleColor: .black, bgColor: .lime40, fontType: .p16Regular16, withAction: true)
                cell.mainButton.layer.borderWidth = 0
            }
            
            return cell
        }
    }
}
