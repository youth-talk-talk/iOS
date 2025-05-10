//
//  PolicyMainViewModel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/1/25.
//

final class PolicyMainViewModel {
    func requestMyInfoAPI(onCompleted: @escaping (String) -> Void) {
        Task {
            let result = await APIManager().requestAPI(
                router: MeRouter.patchMe(.init(nickname: nil, region: nil)),
                type: PatchMeDTO.self)
            switch result {
            case .success(let response):
                onCompleted(response.data.region)
                
            case .failure(let error):
                break
            }
        }
    }
}
