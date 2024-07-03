//
//  SearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

enum SearchViewType {
    
    case policy
    case review
}

class SearchViewController: BaseViewController<SearchView> {
    
    var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    
    var searchViewType: SearchViewType
    
    init(searchViewType: SearchViewType) {
        self.searchViewType = searchViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        
        let placeHolder = "검색"
        
        searchBar.layer.masksToBounds = true
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.leftView?.tintColor = .black
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.placeholder = placeHolder
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.font: FontManager.font(.p16Regular24), .foregroundColor: UIColor.gray50])
        searchBar.backgroundColor = .gray10
        searchBar.layer.cornerRadius = 10
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    override func bind() {
        
        searchBar.rx.text
            .bind(with: self) { owner, text in
                print(text)
            }.disposed(by: disposeBag)
    }
}
