//
//  AutoSignInUseCaseInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol AutoSignInUseCaseInterface {
    
    func autoSignIn() -> Single<Bool>
}
