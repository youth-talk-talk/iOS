//
//  ViewModelInterface.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 6/13/24.
//

import Foundation
import RxSwift

protocol ViewModelInterface: AnyObject {
    
    var disposeBag: DisposeBag { get }
    var input: Input { get }
    
    associatedtype Input
    
    associatedtype Output
    
    func transform(input: Input) -> Output
}
