//
//  ResultPolicyViewModel.swift
//  YouthTalkTalk
//
//  Created by 이중엽 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

final class ResultPolicyViewModel: ResultSearchInterface {
    
    private var disposeBag = DisposeBag()
    private var type: [PolicyCategory] = PolicyCategory.allCases
    private let policyUseCase: PolicyUseCase
    
    private var page = 0
    private var body = PolicyConditionBody(categories: [], age: nil, employmentCodeList: [], isFinished: nil, keyword: "")
    
    // Input
    var keyword: String
    var fetchSearchList = PublishRelay<Void>()
    var pageUpdate = PublishRelay<Int>()
    var searchType: ResultSearchType = .policy
    var updatePostScrap = PublishRelay<String>()
    
    // Output
    var searchListRelay = PublishRelay<[ResultSearchSectionItems]>()
    var totalCountRelay = PublishRelay<Int>()
    var errorHandler = PublishRelay<APIError>()
    var scrapStatus = [String: Bool]()
    var scrapStatusRelay = BehaviorRelay<[String: Bool]>(value: [:])
    var successEditPost = PassthroughSubject<Void, Never>()
    
    lazy var successUploadPost = PassthroughSubject<RPEntity, Never>()
    private lazy var uploadedImage: [String] = []
    
    func fetchType() {
        
        dump(type)
    }
    
    var input: ResultSearchInput { return self }
    var output: ResultSearchOutput { return self }
    
    func setKeyword(_ keyword: String) {
        self.keyword = keyword
    }
    
    init(keyword: String = "", type: [PolicyCategory], policyUseCase: PolicyUseCase) {
        self.keyword = keyword
        self.type = type
        self.policyUseCase = policyUseCase
        
        fetchSearchList
            .withUnretained(self)
            .flatMap { owner, _ in
                
                owner.body.categories = type.map { $0.rawValue }
                owner.body.keyword = owner.keyword
                
                return owner.policyUseCase.fetchConditionPolicies(page: owner.page, body: owner.body)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let data):
                    
                    let (policyEntity, totalCount) = data
                    
                    let recentPolicies = policyEntity.map { ResultSearchSectionItems.resultPolicy($0) }
                    
                    owner.searchListRelay.accept(recentPolicies)
                    owner.totalCountRelay.accept(totalCount)
                    
                case .failure(let error):
                    
                    owner.errorHandler.accept(error)
                }
            }.disposed(by: disposeBag)
        
        pageUpdate
            .subscribe(with: self) { owner, newPage in
                
                owner.page = newPage
                owner.fetchSearchList.accept(())
            }
            .disposed(by: disposeBag)
        
        // 스크랩
        updatePostScrap
            .withUnretained(self)
            .flatMap { owner, policyID in
                
                return owner.policyUseCase.updatePolicyScrap(id: policyID)
            }
            .subscribe(with: self) { owner, result in
                
                switch result {
                case .success(let scrapEntity):
                    
                    owner.scrapStatus[scrapEntity.id] = scrapEntity.isScrap
                    owner.scrapStatusRelay.accept(owner.scrapStatus)
                    
                case .failure(let error):
                    owner.errorHandler.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func uploadImages(_ images: [Data?], body: UploadPostBody, _ writeType: WriteType, postId: Int = 0) {
        let images = images.compactMap({ $0 })
        uploadedImage = []
        
        if images.count > 0 {
            // MARK: 이미지가 있을경우 이미지 API 먼저 호출
            images.forEach { data in
                self.policyUseCase.uploadImage(data)
                    .subscribe(onNext: { [weak self] result in
                        guard let self else { return }
                        
                        switch result {
                        case.success(let data):
                            uploadedImage.append(data)
                            
                            var bodyWithImage = body
                            uploadedImage.forEach { imageUrl in
                                bodyWithImage.contentList.append(.init(content: imageUrl, type: "IMAGE"))
                            }
                            
                            // MARK: 이미지 업로드가 모두 완료되어 게시글 작성/수정 API 호출
                            if images.count == uploadedImage.count {
                                
                                // MARK: 게시글 작성 API 호출
                                if writeType == .new {
                                    policyUseCase.uploadPost(bodyWithImage)
                                        .subscribe { [weak self] result in
                                            switch result {
                                            case .success(let data):
                                                self?.successUploadPost.send(RPEntity(postId: data.data.postId, title: data.data.title, content: data.data.content, writerID: data.data.writerId, scraps: 0, scrap: data.data.scrap, comments: 0, policyId: data.data.policyId, policyTitle: data.data.policyTitle))
                                                break
                                            case .failure:
                                                break
                                            }
                                        }
                                        .disposed(by: disposeBag)
                                    
                                } else if writeType == .edit {
                                    // MARK: 게시글 수정 API 호출
                                }
                            }
                            
                        case .failure(let error):
                            break
                        }
                    })
                    .disposed(by: disposeBag)
            }
        } else { // MARK: 이미지가 없을경우 바로 포스트 작성/수정
            if writeType == .new {
                policyUseCase.uploadPost(body)
                    .subscribe { [weak self] result in
                        switch result {
                        case .success(let data):
                            self?.successUploadPost.send(RPEntity(postId: data.data.postId, title: data.data.title, content: data.data.content, writerID: data.data.writerId, scraps: 0, scrap: data.data.scrap, comments: 0, policyId: data.data.policyId, policyTitle: data.data.policyTitle))
                        case .failure(let error):
                            break
                        }
                    }
                    .disposed(by: disposeBag)
            } else if writeType == .edit {
                // MARK: 게시글 수정 API 호출
            }
        }
    }
    
    func updateData(age: Int?, employment: [String], isFinished: Bool?) {
        body.age = age
        body.employmentCodeList = employment
        body.isFinished = isFinished
        
        pageUpdate.accept(0)
    }
    
    func fetchPage() -> Int {
        return page
    }
}

struct PostEditRequestModel: Encodable {
    let title: String
//    let policyId: String?
//    let postType: String
    let contentList: [DetailContentDTO]
//    let addImgUrlList: [String]
//    let deletedImgUrlList: [String]
}

struct PostEditResponseModel: Decodable {
    let status: Int
    let message: String
    let code: String
    let data: PostEditData
}

struct PostEditData: Decodable {
    let postId: Int
    let postType: String
    let title: String
    let content: String
    let policyId: String?
    let policyTitle: String?
    let writerId: Int
    let images: [ImageResponseModel]?
}

struct ImageResponseModel: Decodable {
    let id: Int
    let imgUrl: String
}
