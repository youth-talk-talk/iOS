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
    private var signUpUseCase: SignUpUseCase
    
    var input: SignUpInput { return self }
    var output: SignUpOutput { return self }
    
    // Inputs
    var itemSelectedEvent = PublishRelay<IndexPath>()
    var policyLocationRelay = PublishRelay<Void>()
    var signUpButtonInvalid = PublishRelay<Void>()
    var signUpButtonClicked = PublishRelay<(String, String)>()
    
    // Outputs
    var policyLocations: Driver<[PolicyLocation]>
    var selectedLocation: Driver<PolicyLocation>
    var signUp: Driver<Bool>
    
    
    init(policyLocationUseCase: PolicyLocationUseCase, signUpUseCase: SignUpUseCase) {
        
        self.policyLocationUseCase = policyLocationUseCase
        self.signUpUseCase = signUpUseCase
        
        // 모든 정책 구역 데이터
        policyLocations = policyLocationRelay.map { _ -> [PolicyLocation] in
            
            let allCase = policyLocationUseCase.fetchAllCase(entity: PolicyLocationKR.self)
            
            return allCase
        }
        .asDriver(onErrorJustReturn: [])
        
        
        // 선택된 정책 구역 데이터
        selectedLocation = itemSelectedEvent
            .map { indexPath -> PolicyLocation in
                
                return policyLocationUseCase.fetchLocation(indexPath.row, entity: PolicyLocationKR.self)
            }.asDriver(onErrorJustReturn: PolicyLocationKR.seoul)
        
        let signUpResult = PublishRelay<Bool>()
        signUp = signUpResult.asDriver(onErrorJustReturn: false)
        
        // 회원가입 버튼 클릭
        signUpButtonClicked
            .flatMap { userData in
                
                let (region, nickname) = userData
                let location = policyLocationUseCase.fetchLocationByDisplayName(displayName: region,
                                                                                entity: PolicyLocationKR.self)
                
                return signUpUseCase.signUp(region: location.networkName,
                                            nickname: nickname)
                
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success():
                    
                    signUpResult.accept(true)
                case .failure(let error):
                    
                    // TODO: 에러 처리 필요
                    if error == .alreadyRegisteredUser {
                        print("이미 가입한 유저 처리 추가 필요")
                    }
                    
                    signUpResult.accept(false)
                }
                
            }.disposed(by: disposeBag)
    }
    
    
}
