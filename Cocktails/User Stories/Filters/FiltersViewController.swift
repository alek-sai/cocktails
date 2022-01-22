//
//  FiltersViewController.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import UIKit.UIView
import SnapKit
import RxSwift
import RxCocoa

protocol FiltersViewControllerProtocol {
    func setFilters(_ categories: [Category])
}

class FiltersViewController: UIViewController {
    
    // MARK: Linking
    
    var presenter: FiltersPresenter!
    
    // MARK: UI Elements
    
    private let tableView = UITableView()
    private let bottomView = UIView()
    private let applyButton = UIButton(type: .system)
    
    // MARK: Bindables
    
    private let disposeBag = DisposeBag()
    private let categoriesSubject = PublishSubject<[Category]>()
    private(set) lazy var categoriesObservable: Observable<[Category]> = categoriesSubject.asObservable()
    
    // MARK: VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        bind()
        
        presenter.viewDidLoad()
    }
    
    // MARK: Set up
    
    private func setup() {
        view.backgroundColor = .white
        
        view.addSubview(bottomView)
        view.addSubview(tableView)
        
        bottomView.addSubview(applyButton)
        
        ButtonStyles.blueButton(applyButton)
        applyButton.setTitle(R.string.localizable.filtersApply_buttonTitle(), for: .normal)
        
        tableView.register(FilterCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func layout() {
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(bottomView.snp.top).offset(10)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-40)
            make.leading.equalTo(bottomView.snp.leading).offset(20)
            make.trailing.equalTo(bottomView.snp.trailing).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomView.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func bind() {
        categoriesObservable.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: FilterCell.self)) { row, element, cell in
            cell.configureCell(with: element)
        }
        .disposed(by: disposeBag)
        
        categoriesObservable.subscribe(onNext: { [weak self] nextCategories in
            guard let self = self else { return }
            
            let isChanged = self.presenter.checkIfFilterChanged(nextCategories)
            
            self.applyButton.isEnabled = isChanged
            self.applyButton.backgroundColor = isChanged ? R.color.accentColor() : R.color.disabledColor()
        })
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        applyButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.applyFilters()
        }.disposed(by: self.disposeBag)
    }
    
}

// MARK: UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            tableView.cellForRow(at: indexPath)?.contentView.alpha = 0.3
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            tableView.cellForRow(at: indexPath)?.contentView.alpha = 1.0
        }
        
        presenter.toggleCategoryFilter(indexPath.row)
    }
    
}

// MARK: FiltersViewControllerProtocol

extension FiltersViewController: FiltersViewControllerProtocol {

    func setFilters(_ categories: [Category]) {
        categoriesSubject.onNext(categories)
    }
    
}
