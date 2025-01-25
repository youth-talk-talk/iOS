//
//  SearchPolicyView.swift
//  YouthTalkTalk
//
//  Created by 김유진 on 11/19/24.
//

import UIKit
import SnapKit
import RxSwift

enum SearchPolicySection {
    case mainSection
}

struct SearchPolicyItem: Hashable {
    let uuid = UUID()
    let id: String
    let policyTitle: String
}

enum loadPurpose {
    case search
    case paging
}

final class SearchPolicyView: UIView {
    private lazy var disposeBag = DisposeBag()
    
    private lazy var loadPurpose: loadPurpose = .paging
    
    private let onPolicyTapped: (SearchPolicyItem) -> Void
    
    private lazy var viewModel = ResultPolicyViewModel(type: PolicyCategory.allCases,
                                                       policyUseCase: PolicyUseCaseImpl(policyRepository: PolicyRepositoryImpl()))
    
    private var dataSource: UITableViewDiffableDataSource<SearchPolicySection, SearchPolicyItem>!
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = FontManager.font(.g20Bold)
        $0.textColor = FontColor.gray60.value
        $0.text = "정책검색"
    }
    
    private lazy var closeButton = UIImageView(image: UIImage(named: "littleXmark"))
    
    private lazy var textFieldBackgroundView = UIView().then {
        $0.backgroundColor = FontColor.gray10.value
        $0.layer.cornerRadius = 25
    }
    
    private lazy var policyTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "정책명을 검색해주세요", font: .p16Regular16)
        $0.delegate = self
    }
    
    private lazy var searchIconImageView = UIImageView(image: UIImage(named: "magnifyingglass")).then {
        $0.onTapped { [weak self] in
            self?.searchPolicy()
        }
    }
    
    private lazy var policyTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "sampleIdentifier")
        $0.backgroundColor = .white
        $0.prefetchDataSource = self
        $0.delegate = self
    }
    
    private lazy var addButton = UILabel().then {
        $0.backgroundColor = .lime40
        $0.text = "추가하기"
        $0.textAlignment = .center
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.textColor = .black
        $0.font = FontManager.font(.p16Regular16)
    }
    
    init(onPolicyTapped: @escaping (SearchPolicyItem) -> Void) {
        self.onPolicyTapped = onPolicyTapped
        
        super.init(frame: .zero)
        
        isHidden = true
        backgroundColor = .black.withAlphaComponent(0.5)
        
        layout()
        addTapEvents()
        
        dataSource = UITableViewDiffableDataSource<SearchPolicySection, SearchPolicyItem>(tableView: policyTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sampleIdentifier", for: indexPath)
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = .lime20
            
            cell.selectedBackgroundView = bgColorView
            cell.textLabel?.text = itemIdentifier.policyTitle
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
        
        policyTableView.dataSource = dataSource
        
        self.viewModel.output.searchListRelay
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                
                let beforeItems = loadPurpose == .paging ? dataSource.snapshot().itemIdentifiers : []
                let itemList: [SearchPolicyItem] = items.map { SearchPolicyItem(id: $0.policy?.policyId ?? "", policyTitle: $0.policy?.title ?? "") }
                var snapshot = NSDiffableDataSourceSnapshot<SearchPolicySection, SearchPolicyItem>()
                
                snapshot.appendSections([.mainSection])
                snapshot.appendItems(beforeItems + itemList, toSection: .mainSection)
                
                dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.fetchSearchList.accept(())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTapEvents() {
        closeButton.onTapped { [weak self] in
            self?.isHidden = true
        }
        
        addButton.onTapped{ [weak self] in
            self?.isHidden = true
        }
    }
    
    private func searchPolicy() {
        loadPurpose = .search
        
        viewModel.output.setKeyword(policyTextField.text ?? "")
        viewModel.input.pageUpdate.accept(0)
    }
    
    private func layout() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(textFieldBackgroundView)
        containerView.addSubview(policyTableView)
        containerView.addSubview(addButton)
        
        textFieldBackgroundView.addSubview(policyTextField)
        textFieldBackgroundView.addSubview(searchIconImageView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(525)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textFieldBackgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        policyTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(searchIconImageView.snp.leading).offset(-10)
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
        policyTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(textFieldBackgroundView.snp.bottom).offset(20)
            $0.bottom.equalTo(addButton.snp.top).offset(-20)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(27)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
}

extension SearchPolicyView: UITableViewDataSourcePrefetching, UITableViewDelegate {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let total = self.dataSource.snapshot().itemIdentifiers(inSection: .mainSection).count
        let currentPage = (total / 10) + 1
        
        loadPurpose = .paging
        
        // 끝에서 5개의 아이템 이내일 경우 다음 페이지 로드 요청
        if let max = indexPaths.map({ $0.item }).max(), max >= total - 2 {
            viewModel.input.pageUpdate.accept(currentPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onPolicyTapped(dataSource.snapshot().itemIdentifiers[indexPath.item])
    }
}

extension SearchPolicyView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPolicy()
        
        return true
    }
}
