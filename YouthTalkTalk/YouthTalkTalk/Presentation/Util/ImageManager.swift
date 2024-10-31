//
//  ImageManager.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 10/27/24.
//

import UIKit

final class ImageManager {
    
    // URL 문자열을 이미지로 변환하여 표시하는 함수
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // URL 문자열을 URL 객체로 변환
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        // URL로부터 데이터를 비동기로 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            // 에러나 데이터가 없는 경우 처리
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // 이미지 로드 완료
            completion(image)
        }.resume()
    }
}


