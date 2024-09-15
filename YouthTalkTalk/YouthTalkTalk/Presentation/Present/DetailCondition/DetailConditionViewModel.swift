//
//  DetailConditionViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 9/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailConditionViewModel {
    
    let disposeBag = DisposeBag()
    
    var selectedStatus: [EmploymentStatus] = [.all]
    var selectedDeadlineStatus: DeadlineStatus = .all
    var age: String = ""
    
    let selectedIndex = BehaviorRelay(value: IndexPath(item: 0, section: 1))
    let selectedDeadlineIndex = BehaviorRelay(value: IndexPath(item: 0, section: 2))
    let ageInputEvent = PublishRelay<String>()
    let applyTapEvent = PublishRelay<Void>()
    
    let selectedIndexEvent = PublishRelay<Void>()
    let isButtonEnabled = PublishRelay<Bool>()
    
    var result: ((Int?, [String], Bool?) -> ())?
    
    init() {
        
        selectedIndex.subscribe(with: self) { owner, indexPath in
            
            let status = EmploymentStatus(rawValue: indexPath.item) ?? .all
            
            if status == .all {
                owner.selectedStatus = [.all]
            } else {
                
                // Handle other statuses
                if owner.selectedStatus.contains(.all) {
                    owner.selectedStatus.removeAll { $0 == .all }
                }
                
                if owner.selectedStatus.contains(status) {
                    owner.selectedStatus.removeAll { $0 == status }
                } else {
                    owner.selectedStatus.append(status)
                }
            }
            
            if owner.selectedStatus == [] {
                owner.selectedStatus = [.all]
            }
            
            owner.selectedIndexEvent.accept(())
            owner.updateButtonState()
        }
        .disposed(by: disposeBag)
        
        selectedDeadlineIndex.subscribe(with: self) { owner, indexPath in
            
            let status = DeadlineStatus(rawValue: indexPath.item) ?? .all
            
            if owner.selectedDeadlineStatus == status {
                owner.selectedDeadlineStatus = .all
            } else {
                owner.selectedDeadlineStatus = status
            }
            
            owner.selectedIndexEvent.accept(())
            owner.updateButtonState()
        }
        .disposed(by: disposeBag)
        
        ageInputEvent.subscribe(with: self) { owner, age in
            owner.age = age
            owner.updateButtonState()
        }
        .disposed(by: disposeBag)
        
        applyTapEvent.subscribe(with: self) { owner, _ in
            
            var selectedStatus: [String] = owner.selectedStatus.map { $0.code } // employment
            
            if selectedStatus.contains("") {
                selectedStatus = []
            }
            
            let selectedDeadlineStatus: Bool? = owner.selectedDeadlineStatus.status
            let age: Int? = Int(owner.age)
            
            owner.result?(age, selectedStatus, selectedDeadlineStatus)
        }
        .disposed(by: disposeBag)
    }
    
    private func updateButtonState() {
        let isAgeValid = !age.isEmpty
        
        let shouldEnableButton = isAgeValid
        
        // 버튼 활성화 상태 업데이트
        isButtonEnabled.accept(shouldEnableButton)
    }
}
