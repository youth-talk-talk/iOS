//
//  PolicyDetailViewController.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 5/26/25.
//

import UIKit

final class PolicyDetailViewController: RootViewController {
    
    private lazy var shareImageView = UIImageView(image: .share)
    
    private lazy var bookmarkImageView = UIImageView(image: .bookmark)
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var containerView = UIView()
    
    private lazy var tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.designed(font: .p18Semi)
        $0.numberOfLines = 2
        $0.text = "타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀"
    }
    
    private lazy var policySummaryLabel = UILabel().then {
        $0.designed(text: "한 눈에 보는 정책 요약", font: .p16SemiBold)
    }
    
    private lazy var policySummaryImageView = UIImageView(image: .eyes)
    
    private lazy var topDeadLineLabel = UILabel().then {
        $0.designed(text: "상시 모집", font: .p16SemiBold, textColor: .accentRed)
    }
    
    private lazy var grayStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .gray30
        $0.layer.cornerRadius = moderate(6)
        $0.spacing = moderate(13)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: moderate(16), left: moderate(16), bottom: moderate(16), right: moderate(16))
    }
    
    private lazy var hostView = UIView()
    private lazy var hostTitleLabel = UILabel().then {
        $0.designed(text: "주관 기관", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var hostLabel = UILabel().then {
        $0.designed(text: "1", font: .p14Regular, textColor: .gray90)
    }
    
    private lazy var categoryView = UIView()
    private lazy var categoryTitleLabel = UILabel().then {
        $0.designed(text: "정책 분야", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.designed(text: "2", font: .p14Regular, textColor: .gray90)
    }
    
    private lazy var deadlineView = UIView()
    private lazy var deadlineTitleLabel = UILabel().then {
        $0.designed(text: "신청 기간", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var deadlineLabel = UILabel().then {
        $0.designed(text: "3", font: .p14Regular, textColor: .gray90)
    }
    
    private lazy var summaryView = UIView()
    private lazy var summaryTitleLabel = UILabel().then {
        $0.designed(text: "정책 요약", font: .p14Regular, textColor: .gray80)
    }
    
    private lazy var summaryArrowImageView = UIImageView(image: .arrowUpBlack)
    
    private lazy var summaryContentLabel = PaddedLabel(topBottom: moderate(14), leftRight: moderate(14)).then {
        $0.text = "summary contentsummary contentsummary contentsummary contentsummary contentsummary contentsummary contentsummary contentsummary contentsummary content"
        $0.numberOfLines = 0
        $0.backgroundColor = .gray10
        $0.layer.cornerRadius = moderate(6)
        $0.clipsToBounds = true
        $0.font = FontManager.font(.p14Regular)
    }
    
    private lazy var noticeView = UIView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderate(10)
    }
    
    private lazy var noticeImageView = UIImageView(image: .redNotice)
    
    private lazy var noticeTitleLabel = UILabel().then {
        $0.designed(text: "알려드립니다!", font: .p14Regular)
    }
    
    private lazy var noticeContentLabel = UILabel().then {
        $0.designed(text: "상시모집의 경우 주관부처의 사업여부에 따라 조기 마감될 수 있습니다. 반드시 사이트를 통한 사업실행 여부를 확인해 주세요.",
                    font: .p14Regular,
                    textColor: .gray80)
        $0.numberOfLines = 0
    }
    
    private lazy var linkContainerStackView = UIStackView()
    
    private lazy var linkView = UIView().then {
        $0.layer.borderColor = UIColor.gray40.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderate(10)
    }
    
    private lazy var linkStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = moderate(10)
        $0.alignment = .center
    }
    
    private lazy var linkImageView = UIImageView(image: .link)
    
    private lazy var linkLabel = UILabel().then {
        $0.designed(text: "사이트에서 자세히 보기", font: .p14Regular)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private lazy var conditionTitleLabel = UILabel().then {
        $0.designed(text: "신청자격", font: .p16SemiBold)
    }
    
    private lazy var conditionLabel = UILabel().then {
        $0.designed(text: "신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격", font: .p16Regular16)
        $0.numberOfLines = 0
    }
    
    private lazy var contentTitleLabel = UILabel().then {
        $0.designed(text: "지원내용", font: .p16SemiBold)
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.designed(text: "신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격", font: .p16Regular16)
        $0.numberOfLines = 0
    }
    
    private lazy var wayTitleLabel = UILabel().then {
        $0.designed(text: "신청방법", font: .p16SemiBold)
    }
    
    private lazy var wayLabel = UILabel().then {
        $0.designed(text: "신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격신청자격", font: .p16Regular16)
        $0.numberOfLines = 0
    }
    
    private lazy var lineView2 = UIView().then {
        $0.backgroundColor = .gray30
    }
    
    private var link: String? = nil
    
    init(policyId: String) {
        super.init(nibName: nil, bundle: nil)
        
        Task {
            let result = await APIManager().requestAPI(
                router: PolicyRouter.fetchPolicyDetail(id: policyId),
                type: DetailPolicyDTO.self)
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.setBind(data.data)
                }
                
            case .failure:
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBind(_ info: DetailPolicyDataDTO) {
        layout()
        
        insertTagView(text: info.category)
        insertTagView(text: info.region)
        insertTagView(text: info.recruitmentType)
        
        
        topDeadLineLabel.text = info.recruitmentType
        
        if info.recruitmentType == "상시 모집" || info.recruitmentType.contains("D-") {
            topDeadLineLabel.textColor = .accentRed
        } else if info.recruitmentType == "모집 마감" {
            topDeadLineLabel.textColor = .gray80
        }
        
        hostLabel.text = info.hostDep
        summaryContentLabel.text = info.introduction
        titleLabel.text = info.title
        contentLabel.text = info.supportDetail
        deadlineLabel.text = info.applyTerm
        categoryLabel.text = info.category
        wayLabel.text = (info.applStep ?? "") + (info.submitDoc ?? "") == "" ? "공고문 참고 필요" : (info.applStep ?? "") + (info.submitDoc ?? "")
        
        let condition = [
            info.age,
            info.specialization,
            info.addition,
            info.applLimit,
            info.etc,
            info.earnEtc,
            info.major,
            info.education,
            info.marriage,
            info.employment
        ].compactMap { $0 }
         .joined(separator: "\n\n")
        
        conditionLabel.text = condition
        
        linkView.isHidden = info.refUrl1 == nil
        self.link = info.refUrl1
        
        linkView.onTapped {
            guard let url = URL(string: info.refUrl1 ?? "") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        shareImageView.onTapped { [weak self] in
            let items = ["정책을 공유합니다!", URL(string: self?.link ?? "")]

            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self?.present(activityVC, animated: true)
        }
        
        summaryArrowImageView.onTapped { [weak self] in
            guard let self else { return }
            
            summaryContentLabel.isHidden.toggle()
            summaryArrowImageView.image = summaryContentLabel.isHidden ? .arrowDown.withTintColor(.black) : .arrowUpBlack
        }
    }
    
    private func insertTagView(text: String) {
        let view = UIView().then {
            $0.backgroundColor = .gray30
            $0.layer.cornerRadius = moderate(4)
        }
        
        let label = UILabel().then {
            $0.designed(text: text, font: .p12Regular, textColor: .gray80)
        }
        
        view.addSubview(label)
        
        view.snp.makeConstraints {
            $0.height.equalTo(moderate(21))
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderate(6))
        }
        
        tagStackView.addArrangedSubview(view)
    }
    
    private func layout() {
        view.addSubview(shareImageView)
        view.addSubview(bookmarkImageView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(tagStackView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(policySummaryLabel)
        containerView.addSubview(policySummaryImageView)
        containerView.addSubview(topDeadLineLabel)
        containerView.addSubview(grayStackView)
        containerView.addSubview(noticeView)
        containerView.addSubview(linkContainerStackView)
        containerView.addSubview(lineView)
        containerView.addSubview(conditionTitleLabel)
        containerView.addSubview(conditionLabel)
        containerView.addSubview(contentTitleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(wayTitleLabel)
        containerView.addSubview(wayLabel)
        containerView.addSubview(lineView2)
        
        linkContainerStackView.addArrangedSubview(linkView)
        
        grayStackView.addArrangedSubview(hostView)
        grayStackView.addArrangedSubview(categoryView)
        grayStackView.addArrangedSubview(deadlineView)
        grayStackView.addArrangedSubview(summaryView)
        grayStackView.addArrangedSubview(summaryContentLabel)
        
        hostView.addSubview(hostTitleLabel)
        hostView.addSubview(hostLabel)
        
        categoryView.addSubview(categoryTitleLabel)
        categoryView.addSubview(categoryLabel)
        
        deadlineView.addSubview(deadlineTitleLabel)
        deadlineView.addSubview(deadlineLabel)
        
        summaryView.addSubview(summaryTitleLabel)
        summaryView.addSubview(summaryArrowImageView)
        
        noticeView.addSubview(noticeImageView)
        noticeView.addSubview(noticeTitleLabel)
        noticeView.addSubview(noticeContentLabel)
        
        linkView.addSubview(linkStackView)
        linkStackView.addArrangedSubview(linkLabel)
        linkStackView.addArrangedSubview(linkImageView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backImageView.snp.bottom).offset(moderate(20))
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.height.equalTo(moderate(21))
        }
        
        shareImageView.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.trailing.equalTo(bookmarkImageView.snp.leading).offset(moderate(-10))
        }
        
        bookmarkImageView.snp.makeConstraints {
            $0.centerY.equalTo(backImageView)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(moderate(10))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        policySummaryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderate(20))
            $0.leading.equalTo(titleLabel)
        }
        
        policySummaryImageView.snp.makeConstraints {
            $0.centerY.equalTo(policySummaryLabel)
            $0.leading.equalTo(policySummaryLabel.snp.trailing).offset(moderate(6))
            $0.size.equalTo(moderate(24))
        }
        
        topDeadLineLabel.snp.makeConstraints {
            $0.centerY.equalTo(policySummaryLabel)
            $0.trailing.equalToSuperview().inset(moderate(16))
        }
        
        grayStackView.snp.makeConstraints {
            $0.top.equalTo(policySummaryLabel.snp.bottom).offset(moderate(15))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        hostTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        hostLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        categoryTitleLabel.snp.makeConstraints {
            $0.centerY.leading.top.bottom.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        deadlineTitleLabel.snp.makeConstraints {
            $0.centerY.leading.top.bottom.equalToSuperview()
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        summaryTitleLabel.snp.makeConstraints {
            $0.centerY.leading.top.bottom.equalToSuperview()
        }
        
        summaryArrowImageView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.size.equalTo(moderate(20))
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(grayStackView.snp.bottom).offset(moderate(16))
            $0.trailing.leading.equalToSuperview().inset(moderate(16))
        }
        
        noticeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderate(16))
            $0.leading.equalToSuperview().inset(moderate(16))
            $0.size.equalTo(moderate(20))
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(noticeImageView)
            $0.leading.equalTo(noticeImageView.snp.trailing).offset(moderate(4))
        }
        
        noticeContentLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.bottom).offset(moderate(10))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderate(16))
        }
        
        linkContainerStackView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom).offset(moderate(16))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        linkView.snp.makeConstraints {
            $0.height.equalTo(moderate(40))
        }
        
        linkStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        linkImageView.snp.makeConstraints {
            $0.size.equalTo(moderate(16))
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(linkContainerStackView.snp.bottom).offset(moderate(30))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(10))
        }
        
        conditionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderate(20))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(conditionTitleLabel.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(conditionLabel.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        wayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(moderate(30))
            $0.leading.equalToSuperview().inset(moderate(16))
        }
        
        wayLabel.snp.makeConstraints {
            $0.top.equalTo(wayTitleLabel.snp.bottom).offset(moderate(14))
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
        }
        
        lineView2.snp.makeConstraints {
            $0.top.equalTo(wayLabel.snp.bottom).offset(moderate(30))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderate(10))
            $0.bottom.equalToSuperview()
        }
    }
}
