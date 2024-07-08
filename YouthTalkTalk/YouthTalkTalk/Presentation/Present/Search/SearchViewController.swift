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
    
    case recent
    case result
}

final class SearchViewController: BaseViewController<SearchView> {
    
    var viewModel: SearchInterface
    
    let clearSearchView = ClearSearchView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    init(viewModel: SearchInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureNavigation() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearSearchView)
    }
    
    override func bind() {
        
        // MARK: Inputs
        // 검색
        clearSearchView.textField.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance) // 입력 후 0.3초
            .distinctUntilChanged() // 값이 변경된 경우에만 이벤트 전달
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposeBag)
        
        // 검색 내용 삭제
        clearSearchView.cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.clearSearchView.textField.text = nil
                owner.viewModel.input.cancelButtonClicked.accept(())
            }
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        // 화면 타입
        viewModel.output.searchTypeEvent
            .bind(with: self) { owner, viewType in
                
                print(viewType)
                
                switch viewType {
                case .recent:
                    
                    let childVC = RecentSearchViewController()
                    
                    self.addChild(childVC)
                    owner.layoutView.flexView.addSubview(childVC.layoutView)
                    
                    childVC.layoutView.frame = owner.layoutView.flexView.bounds
                    childVC.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    childVC.didMove(toParent: self)
                    
                case .result:
                    
                    let childVC = ResultSearchViewController()
                    
                    self.addChild(childVC)
                    owner.layoutView.flexView.addSubview(childVC.layoutView)
                    
                    childVC.layoutView.frame = owner.layoutView.flexView.bounds
                    childVC.layoutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    childVC.didMove(toParent: self)
                }
                
            }.disposed(by: disposeBag)
    }
}
