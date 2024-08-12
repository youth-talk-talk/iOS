//
//  SearchViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: SearchInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let userDefaults = UserDefaults.standard
    
    var type: RecentSearchType
    
    var input: SearchInput { return self }
    var output: SearchOutput { return self }
    
    // Inputs
    var searchButtonClicked = PublishRelay<String>()
    var cancelButtonClicked = PublishRelay<Void>()
    
    // Outputs
    var searchTypeEvent = BehaviorRelay<SearchViewType>(value: .recent)
    
    init(type: RecentSearchType) {
        self.type = type
        
        // 검색
        searchButtonClicked
            .subscribe(with: self) { owner, text in
                
                if text.isEmpty { return }
                
                owner.userDefaults.saveRecentSearch(searchText: text, type: .policy)
                // 결과창 화면으로 변경
                owner.searchTypeEvent.accept(text.isEmpty ? .recent : .result)
                
            }.disposed(by: disposeBag)
        
        // 검색 취소
        cancelButtonClicked
            .subscribe(with: self) { owner, _ in
                
                // 최근검색창 화면으로 변경
                owner.searchTypeEvent.accept(.recent)
            }.disposed(by: disposeBag)
    }
}
