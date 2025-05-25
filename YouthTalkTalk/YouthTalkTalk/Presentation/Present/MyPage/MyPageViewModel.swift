//
//  MyPageViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/30/24.
//

import Foundation

final class MyPageViewModel {
    
    func getMyInfo(_ onSuccess: @escaping (MeDTO) -> Void) {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.requestMe,
                type: MeDTO.self)
            switch result {
            case .success(let response):
                onSuccess(response)
                
            case .failure:
                break
            }
        }
    }
    
    func editMyInfo(nickname: String?, region: String, onSuccess: @escaping () -> Void) {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.patchMe(.init(nickname: nickname, region: region)),
                type: PatchMeDTO.self)
            switch result {
            case .success:
                onSuccess()
                
            case .failure:
                break
            }
        }
    }
}
