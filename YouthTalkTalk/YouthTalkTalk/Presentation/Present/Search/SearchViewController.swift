//
//  SearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/1/24.
//

import UIKit

final class SearchViewController: RootViewController, UITextFieldDelegate {
    private let viewModel = SearchViewModel()
    
    // MARK: 검색 바
    private let searchBarView = UIView().then {
        $0.backgroundColor = .gray30
        $0.layer.cornerRadius = 6
    }
    
    private let searchImageView = UIImageView(image: .search.withTintColor(.gray70))
    
    private lazy var searchTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "검색어를 입력해주세요.",
                               textColor: .gray70,
                               font: .p16Regular16)
        $0.tintColor = .greenNormal
        $0.clearButtonMode = .whileEditing
        $0.delegate = self
    }
    
    // MARK: 최근 검색
    private let recentSearchLabel = UILabel().then {
        $0.designed(text: "최근 검색", font: .p14Bold)
    }
    
    private let deleteRecentLabel = UILabel().then {
        $0.designed(text: "전체 삭제", font: .p12Regular, textColor: .gray80)
        $0.isHidden = true
    }
    
    private let recentSearchStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    // MARK: 검색 결과 필터
    private lazy var searchFilterCollectionView = SearchFilterCollectionView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cells: SearchFilterCell.self)
        $0.isHidden = true
    }
    
    private let recnetSearchEmptyView = EmptyView(text: "최근 검색된 내역이 없습니다.")
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray30
        $0.isHidden = true
    }
    
    private let resultCountLabel = UILabel().then {
        $0.designed(text: "총 0건", font: .p14Regular)
        $0.isHidden = true
    }
    
    private let sortStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(2)
        $0.alignment = .center
        $0.isHidden = true
    }
    
    private let sortLabel = UILabel().then {
        $0.designed(text: "최신순", font: .p14Regular)
    }
    
    private let sortArrowImageView = UIImageView(image: .arrowDown.withTintColor(.black))
    
    private lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 35, height: 123)

        $0.showsVerticalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.contentInset.left = 16
        $0.contentInset.right = 16
        $0.showsLargeContentViewer = false
        $0.register(cells: PolicyCell.self)
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRecentSearch()
        
        viewModel.onError = { [weak self] error in
            // TODO: 에러 얼럿 표시
        }
        
        viewModel.onSearched = { [weak self] searchedPolicy in
            print("|| \(searchedPolicy)")
        }
        
        view.addSubview(searchBarView)
        view.addSubview(recentSearchLabel)
        view.addSubview(deleteRecentLabel)
        view.addSubview(recnetSearchEmptyView)
        view.addSubview(recentSearchStackView)
        view.addSubview(searchFilterCollectionView)
        view.addSubview(dividerView)
        
        view.addSubview(resultCountLabel)
        view.addSubview(sortStackView)
        view.addSubview(resultCollectionView)
        
        sortStackView.addArrangedSubview(sortLabel)
        sortStackView.addArrangedSubview(sortArrowImageView)
        
        searchBarView.addSubviews([searchImageView,
                                   searchTextField])
        
        searchBarView.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.leading.equalTo(backImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
            $0.size.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview()
        }
        
        recentSearchLabel.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(30)
            $0.leading.equalTo(backImageView)
        }
        
        deleteRecentLabel.snp.makeConstraints {
            $0.centerY.equalTo(recentSearchLabel)
            $0.trailing.equalTo(searchBarView)
        }
        
        recnetSearchEmptyView.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        recentSearchStackView.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchFilterCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(20)
            $0.left.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(searchFilterCollectionView.snp.bottom).offset(moderate(14))
            $0.height.equalTo(moderate(1))
            $0.width.centerX.equalToSuperview()
        }
        
        resultCountLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(moderate(10))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        sortStackView.snp.makeConstraints {
            $0.centerY.equalTo(resultCountLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        sortArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(16))
        }
        
        resultCollectionView.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom).offset(moderate(10))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
            $0.bottom.equalToSuperview()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        
        UserDefaults.standard.saveRecentSearch(searchText: text,
                                               type: .policy)
        
        viewModel.requestSearchAPI(text)
        
        showSearchResultViews()
        
        return true
    }
    
    private func setRecentSearch() {
        let recentSearchList = UserDefaults.standard.getRecentSearchList(type: .policy)
        
        showRecentSearchEmptyView(recentSearchList.isEmpty)
        
        // 최근 검색어 표시
        recentSearchList.forEach { recentSearch in
            let recentSearchItem = RecentSearchItemView(text: recentSearch)
            
            recentSearchItem.snp.makeConstraints {
                $0.height.equalTo(30)
            }
            
            recentSearchItem.xImageView.onTapped { [weak self] in
                self?.recentSearchStackView.removeArrangedSubview(recentSearchItem)
                recentSearchItem.removeFromSuperview()
                UserDefaults.standard.removeRecentSearch(searchText: recentSearch,
                                                         type: .policy)
                
                // 최근 검색어가 다 삭제된 경우 엠티뷰 표시
                if ((self?.recentSearchStackView.arrangedSubviews.isEmpty) != nil) {
                    self?.showRecentSearchEmptyView(true)
                }
            }
            
            recentSearchStackView.addArrangedSubview(recentSearchItem)
        }
        
        // 최근 검색어 전체 삭제
        deleteRecentLabel.onTapped { [weak self] in
            self?.showRecentSearchEmptyView(true)
            
            recentSearchList.forEach { search in
                UserDefaults.standard.removeRecentSearch(searchText: search,
                                                         type: .policy)
            }
        }
    }
    
    private func showSearchResultViews(_ isShow: Bool = true) {
        searchFilterCollectionView.isHidden = !isShow
        dividerView.isHidden = !isShow
        resultCountLabel.isHidden = !isShow
        sortStackView.isHidden = !isShow
        resultCollectionView.isHidden = !isShow
    }
    
    private func hideRecentSearchView() {
        recnetSearchEmptyView.isHidden = true
        recentSearchStackView.isHidden = true
        deleteRecentLabel.isHidden = true
    }
    
    private func showRecentSearchEmptyView(_ isShow: Bool) {
        recnetSearchEmptyView.isHidden = isShow
        recentSearchStackView.isHidden = !isShow
        deleteRecentLabel.isHidden = !isShow
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchFilterCollectionView {
            return viewModel.filters.count
            
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchFilterCollectionView {
            guard let cell: SearchFilterCell = collectionView.dequeueCell(for: indexPath) else { return .init() }
            
            let filterTitle = viewModel.filters[indexPath.row]
            
            cell.setTitle(filterTitle)
            
            cell.onTapped { [weak self] in
                let vc = DetailFilterBottomSheetViewController()
                
                if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
                
                self?.present(vc, animated: true, completion: nil)
            }
            
            return cell
        } else {
            guard let cell: PolicyCell = collectionView.dequeueCell(for: indexPath) else { return UICollectionViewCell() }
            
            cell.setStyle(.border)

            return cell
        }
    }
}
