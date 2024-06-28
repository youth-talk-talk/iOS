//
//  SplashInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/28/24.
//

import Foundation

protocol SplashInterface: SplashInput, SplashOutput {
    
    var input: SplashInput { get }
    var output: SplashOutput { get }
}
