//
//  AppleLoginInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/23/24.
//

import Foundation

protocol SignInInterface: SignInInput, SignInOutput {
    
    var input: SignInInput { get }
    var output: SignInOutput { get }
}
