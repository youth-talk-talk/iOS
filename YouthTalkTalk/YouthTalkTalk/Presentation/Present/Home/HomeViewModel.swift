//
//  HomeViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 7/15/24.
//
//

import UIKit

final class HomeViewModel {
    private(set) var categories: [(UIImage, String)] = [(.total, "전체"),
                                                        (.home, "주거"),
                                                        (.education, "교육"),
                                                        (.work, "일자리"),
                                                        (.culture, "복지"),
                                                        (.apply, "참여 권리")]
}
