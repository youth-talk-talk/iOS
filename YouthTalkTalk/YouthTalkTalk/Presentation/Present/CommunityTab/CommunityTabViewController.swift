//
//  CommunityTabViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/7/24.
//

import UIKit
import Tabman
import Pageboy
import FlexLayout

class CommunityTabViewController: TabmanViewController {
    
    var types: [MainContentsType] = []
    
    private var viewControllers: [UIViewController] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
        
        let reviewUseCase = ReviewUseCaseImpl(reviewRepository: ReviewRepositoryImpl())
        let reviewViewModel = ReviewViewModel(rpUseCase: reviewUseCase)
        let reviewController = CommunityViewController(viewModel: reviewViewModel)
        
        let postUseCase = PostUseCaseImpl(postRepository: PostRepositoryImpl())
        let postViewModel = PostViewModel(rpUseCase: postUseCase)
        let postController = CommunityViewController(viewModel: postViewModel)
        
        viewControllers = [reviewController, postController]
        types = [reviewViewModel.type, postViewModel.type]
        
        self.dataSource = self
        self.isScrollEnabled = true
        
        // Create bar
        let bar = TMHidingBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 0
        
        bar.backgroundView.style = .clear
        bar.backgroundColor = .gray40
        
        bar.indicator.tintColor = .black
        bar.indicator.cornerStyle = .eliptical
        bar.indicator.weight = .custom(value: 3)
        
        bar.buttons.customize { (button) in
            button.tintColor = .gray40
            button.selectedTintColor = .black
            button.backgroundColor = .white
            button.font = FontManager.font(.g14Bold)
        }
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}

extension CommunityTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        pageboyViewController.view.backgroundColor = .white
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = types[index].title
        return TMBarItem(title: title)
    }
}
