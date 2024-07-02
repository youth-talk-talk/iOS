//
//  SearchViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/1/24.
//

import UIKit
import PinLayout
import FlexLayout

class SearchViewController: BaseViewController<SearchView> {
    
    override func configureNavigation() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeSearchBar())
    }
}

extension SearchViewController {
    
    private func makeSearchBar() -> UISearchBar {
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        
        let placeHolder = "검색"
        
        searchBar.layer.masksToBounds = true
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.leftView?.tintColor = .black
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.placeholder = placeHolder
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.font: FontManager.font(.p16Regular24), .foregroundColor: UIColor.gray50])
        searchBar.backgroundColor = .gray10
        searchBar.layer.cornerRadius = 10
        
        searchBar.becomeFirstResponder()
        
        return searchBar
    }
}
