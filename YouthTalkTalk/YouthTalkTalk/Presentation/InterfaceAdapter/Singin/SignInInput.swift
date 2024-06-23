//
//  SignInInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation
import RxCocoa

protocol SignInInput {
    
    var appleSignInButtonClicked: PublishRelay<Void> { get }
}
