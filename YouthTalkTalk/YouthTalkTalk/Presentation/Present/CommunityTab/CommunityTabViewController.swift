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
    
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rpUseCase = ReviewUseCaseImpl(reviewRepository: ReviewRepositoryImpl())
        let viewModel = ReviewViewModel(rpUseCase: rpUseCase)
        let reviewController = CommunityViewController(viewModel: viewModel)
        
        viewControllers.append(reviewController)
        
        self.dataSource = self
        self.isScrollEnabled = false
        
        // Create bar
        let bar = TMBar.ButtonBar()
        
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
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
