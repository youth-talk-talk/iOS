//
//  SettingRegionViewModel.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 2/4/25.
//

import Foundation

import Alamofire
import RxSwift

final class SettingViewModel {
    private var disposeBag = DisposeBag()
    
    var onSavedInfo: ((PatchMeDataDTO) -> Void)?
    var selectedNewRegion: PolicyLocationKR?
    var writtenNickName: String?
    
    private let apiManager = APIManager()
    
    func saveChangedInfo() {
        apiManager.request(router: MeRouter.patchMe(.init(nickname: writtenNickName,
                                                          region: selectedNewRegion?.networkName)),
                           type: PatchMeDTO.self).asObservable()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.onSavedInfo?(success.data)
                    
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

struct ChangedRegion: Encodable {
    let nickname: String?
    let region: String?
}
