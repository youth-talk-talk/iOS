//
//  SplashOutput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation
import RxCocoa

protocol SplashOutput {
    
    var isAutoSignIn: Driver<Bool> { get }
}
