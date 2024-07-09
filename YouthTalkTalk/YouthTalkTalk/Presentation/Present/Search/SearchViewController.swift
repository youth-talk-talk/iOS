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
    
    var currentChildVC: UIViewController?
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
                        switch viewType {
                        case .recent:
                            owner.showRecentSearchViewController()
                        case .result:
                            owner.showResultSearchViewController()
                        }
                    }
                    .disposed(by: disposeBag)
    }
    
    func showRecentSearchViewController() {
           // 기존 child view controller가 RecentSearchViewController가 아닌 경우에만 새로운 child view controller를 추가
           if !(currentChildVC is RecentSearchViewController) {
               // 기존 child view controller 제거
               removeCurrentChildViewController()
               
               // 새로운 child view controller 추가
               let childVC = RecentSearchViewController()
               addChild(childVC)
               layoutView.flexView.addSubview(childVC.layoutView)
               childVC.layoutView.frame = layoutView.flexView.bounds
               childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               childVC.didMove(toParent: self)
               
               // 현재 child view controller 업데이트
               currentChildVC = childVC
           }
       }
       
       func showResultSearchViewController() {
           // 기존 child view controller가 ResultSearchViewController가 아닌 경우에만 새로운 child view controller를 추가
           if !(currentChildVC is ResultSearchViewController) {
               // 기존 child view controller 제거
               removeCurrentChildViewController()
               
               // 새로운 child view controller 추가
               let childVC = ResultSearchViewController()
               addChild(childVC)
               layoutView.flexView.addSubview(childVC.layoutView)
               childVC.layoutView.frame = layoutView.flexView.bounds
               childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               childVC.didMove(toParent: self)
               
               // 현재 child view controller 업데이트
               currentChildVC = childVC
           }
       }
       
       func removeCurrentChildViewController() {
           // 현재 child view controller 제거
           if let childVC = currentChildVC {
               childVC.willMove(toParent: nil)
               childVC.view.removeFromSuperview()
               childVC.removeFromParent()
               currentChildVC = nil
           }
       }
}
