//
//  SignUpViewController.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/16/24.
//

import UIKit
import RxCocoa
import RxSwift

final class SignUpViewController: BaseViewController<SignUpView> {
    
    var viewModel: SignUpInterface
    let apiManager = APIManager()
    
    init(viewModel: SignUpInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        
        layoutView.pullDownTableView.delegate = self
        layoutView.pullDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let gesture = layoutView.regionDropDownView.gestureRecognizers?.first else { return }
        
        // Dropdown(tableview) visible/hidden 토글
        gesture.rx.event
            .bind(with: self) { owner, _ in
                
                owner.layoutView.toggleTableViewHidden()
                
            }.disposed(by: disposeBag)

        
        // MARK: Inputs
        layoutView.pullDownTableView.rx.itemSelected
            .bind(to: viewModel.itemSelectedEvent)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(layoutView.regionDropDownView.regionDropdownLabel.rx.textChanged.asObservable(),
                       layoutView.nicknameTextField.rx.text.asObservable(),
                       layoutView.signUpButton.rx.tap.asObservable())
        .subscribe(with: self) { owner, data in
            
            let (region, nickname, _) = data
            
            guard let region, let nickname else { return }
            
            if region == "" || nickname == "" {
                
                owner.viewModel.input.signUpButtonInvalid.accept(())
                return
            }
            
            let userData = (region, nickname)
            
            owner.viewModel.input.signUpButtonClicked.accept(userData)
            
        }.disposed(by: disposeBag)
        
        // MARK: Ouputs
        // Configure Cell
        viewModel.output.policyLocations
            .drive(layoutView.pullDownTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { _, location, cell in
                
                cell.textLabel?.designed(text: location.displayName, fontType: .p16Regular16, textColor: .gray40)
                cell.backgroundColor = .clear
                
            }.disposed(by: disposeBag)
        
        // Selected Item
        viewModel.output.selectedLocation
            .drive(with: self) { owner, policyLocation in
                
                owner.layoutView.updateLocation(policyLocation)
                
            }.disposed(by: disposeBag)
        
        viewModel.output.signUp
            .drive(with: self) { owner, isSignUp in
                
                if isSignUp {
                    SceneDelegate.makeRootVC()
                } else {
                    print("실패")
                }
            }.disposed(by: disposeBag)
        
        // 이벤트 전달
        viewModel.input.policyLocationRelay.accept(())
    }
}

extension SignUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 36
    }
}
