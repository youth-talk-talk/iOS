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
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        
        UserDefaults.standard.saveRecentSearch(searchText: text,
                                               type: .policy)
        
        viewModel.requestSearchAPI(text)
        
        // 검색할 시, 최근검색 뷰 미노출 / 카테고리 표시
        searchFilterCollectionView.isHidden = false
        
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
        return viewModel.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SearchFilterCell = collectionView.dequeueCell(for: indexPath) else { return .init() }
        
        let filterTitle = viewModel.filters[indexPath.row]
        
        cell.setTitle(filterTitle)
        
        cell.onTapped { [weak self] in
            let vc = DetailFilterBottomSheetViewController()
            
            if let sheet = vc.sheetPresentationController { sheet.detents = [.medium()] }
            
            self?.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
}
