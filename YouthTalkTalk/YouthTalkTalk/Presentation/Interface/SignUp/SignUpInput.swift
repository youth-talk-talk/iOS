//
//  SignUpInput.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation
import RxCocoa

protocol SignUpInput {
    
    var itemSelectedEvent: PublishRelay<IndexPath> { get }
    var policyLocationRelay: PublishRelay<Void> { get }
    var signUpButtonInvalid: PublishRelay<Void> { get }
    var signUpButtonClicked: PublishRelay<(String, String)> { get }
}
