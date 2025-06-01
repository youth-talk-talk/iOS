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
    let id: Int
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
    
    private lazy var titleLabel = UILabel().then {
        $0.designed(text: "정책 검색", font: .p18Semi)
    }
    
    private lazy var closeButton = UIImageView(image: .littleXmark)
    
    private lazy var textFieldBackgroundView = UIView().then {
        $0.backgroundColor = .gray30
        $0.layer.cornerRadius = moderate(6)
    }
    
    private lazy var policyTextField = UITextField().then {
        $0.designedPlaceholder(placeholder: "정책명을 검색해 주세요", font: .p16Regular16)
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
        $0.showsVerticalScrollIndicator = false
    }
    
    init(onPolicyTapped: @escaping (SearchPolicyItem) -> Void) {
        self.onPolicyTapped = onPolicyTapped
        
        super.init(frame: .zero)
        
        isHidden = true
        
        layout()
        addTapEvents()
        
        dataSource = UITableViewDiffableDataSource<SearchPolicySection, SearchPolicyItem>(tableView: policyTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "sampleIdentifier", for: indexPath)
            
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.textLabel?.designed(text: itemIdentifier.policyTitle, font: .p14Regular)
            
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
        
        policyTableView.dataSource = dataSource
        
        self.viewModel.output.searchListRelay
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                
                let beforeItems = loadPurpose == .paging ? dataSource.snapshot().itemIdentifiers : []
                let itemList: [SearchPolicyItem] = items.map { SearchPolicyItem(id: $0.policy?.policyId ?? 0, policyTitle: $0.policy?.title ?? "") }
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
    }
    
    private func searchPolicy() {
        loadPurpose = .search
        
        viewModel.output.setKeyword(policyTextField.text ?? "")
        viewModel.input.pageUpdate.accept(0)
    }
    
    private func layout() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(textFieldBackgroundView)
        addSubview(policyTableView)
        
        textFieldBackgroundView.addSubview(policyTextField)
        textFieldBackgroundView.addSubview(searchIconImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(moderate(68))
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
            $0.leading.trailing.equalToSuperview().inset(moderate(16))
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
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldBackgroundView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
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
        isHidden = true
        onPolicyTapped(dataSource.snapshot().itemIdentifiers[indexPath.item])
    }
}

extension SearchPolicyView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPolicy()
        
        return true
    }
}
