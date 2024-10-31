//
//  RecentSearchViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RecentSearchViewModel: RecentSearchInterface {
    
    private let disposeBag = DisposeBag()
    private let userDefualts = UserDefaults.standard
    
    var type: MainContentsType
    
    // Input
    var clickRecentKeywordEvent: ((String) -> Void)?
    
    var clickRecentKeyword = PublishRelay<String>()
    var fetchRecentSearchList = PublishRelay<Void>()
    var removeRecentSearchList = PublishRelay<String>()
    
    // Output
    var recentSearchListRelay = PublishRelay<[String]>()
    
    var input: RecentSearchInput { return self }
    var output: RecentSearchOutput { return self }
    
    init(type: MainContentsType) {
        self.type = type
        
        fetchRecentSearchList
            .withUnretained(self)
            .map { owner, _ in
                
                owner.userDefualts.fetchRecentSearchList(type: type)
            }.subscribe(with: self) { owner, recentSearchList in
                
                owner.recentSearchListRelay.accept(recentSearchList)
            }
            .disposed(by: disposeBag)
        
        removeRecentSearchList
            .subscribe(with: self) { owner, idx in
                
                owner.userDefualts.removeRecentSearch(searchText: idx, type: type)
                owner.fetchRecentSearchList.accept(())
            }
            .disposed(by: disposeBag)
        
        clickRecentKeyword
            .subscribe(with: self) { owner, keyword in
                
                owner.clickRecentKeywordEvent?(keyword)
            }
            .disposed(by: disposeBag)
    }
}
