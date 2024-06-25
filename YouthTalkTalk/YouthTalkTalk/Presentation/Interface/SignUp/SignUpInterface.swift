//
//  SignUpInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/25/24.
//

import Foundation

protocol SignUpInterface: SignUpInput, SignUpOutput {
    
    var input: SignUpInput { get }
    var output: SignUpOutput { get }
}
