//
//  SignUpViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SignUpViewModel: SignUpInterface {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var policyLocationUseCase: PolicyLocationUseCase
    
    var input: SignUpInput { return self }
    var output: SignUpOutput { return self }
    
    // Inputs
    var itemSelectedEvent = PublishRelay<IndexPath>()
    var policyLocationRelay = PublishRelay<Void>()
    
    // Outputs
    var policyLocations: Driver<[PolicyLocation]>
    var selectedLocation: Driver<PolicyLocation>
    
    
    init(policyLocationUseCase: PolicyLocationUseCase) {
        
        self.policyLocationUseCase = policyLocationUseCase
        
        // 모든 정책 구역 데이터
        policyLocations = policyLocationRelay.map { _ -> [PolicyLocation] in
            
            let allCase = policyLocationUseCase.fetchAllCase(entity: PolicyLocationKR.self)
            
            return allCase
        }
        .asDriver(onErrorJustReturn: [])
        
        
        // // 선택된 정책 구역 데이터
        selectedLocation = itemSelectedEvent
            .map { indexPath -> PolicyLocation in
                
                return policyLocationUseCase.fetchLocation(indexPath.row, entity: PolicyLocationKR.self)
            }.asDriver(onErrorJustReturn: PolicyLocationKR.seoul)
    }
}
