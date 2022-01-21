//
//  DrinksViewController.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import UIKit.UIView
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import MBProgressHUD

protocol DrinksViewControllerProtocol {
    func setFilterBadgeEnabled(_ enabled: Bool)
    func reset()
    func addCategory(name: String, drinks: [Drink])
}

class DrinksViewController: UIViewController {
    
    // MARK: Linking
    
    var presenter: DrinksPresenter!
    
    // MARK: UI Elements
    
    private let tableView = UITableView()
    private var hud: MBProgressHUD!
    
    // MARK: Bindables
    
    private let disposeBag = DisposeBag()
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Drink>>(
        configureCell: { (_, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DrinkCell
            cell?.configureCell(with: element)
            return cell ?? UITableViewCell()
        }, titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
    )
    
    var drinks: [SectionModel<String, Drink>] = []
    let drinksSubject = PublishSubject<[SectionModel<String, Drink>]>()
    private(set) lazy var drinksObservable: Observable<[SectionModel<String, Drink>]> = drinksSubject.asObservable()
    
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
        navigationItem.setRightBarButton(UIBarButtonItem(image: R.image.filters(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onFiltersTap)), animated: false)
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.register(DrinkCell.self, forCellReuseIdentifier: "Cell")
        
        showHUD()
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    private func bind() {
        drinksObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: Private methods
    
    private func showHUD() {
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.margin = 40
    }
    
    @objc private func onFiltersTap() {
        guard drinks.count > 0 else { return }
        
        presenter.openFilters()
    }
    
}

// MARK: UITableViewDelegate

extension DrinksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            tableView.cellForRow(at: indexPath)?.contentView.alpha = 0.3
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            tableView.cellForRow(at: indexPath)?.contentView.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        74
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let height = max(1, scrollView.contentSize.height - scrollView.frame.height * 2)
        
        guard y > 0 else { return }
        
        if y > height {
            presenter.loadNextDrinkCategory()
        }
    }
    
}

// MARK: DrinksViewControllerProtocol

extension DrinksViewController: DrinksViewControllerProtocol {
    
    func setFilterBadgeEnabled(_ enabled: Bool) {
        if enabled {
            let filtersButton = UIButton(type: .system)
            
            filtersButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            filtersButton.setImage(R.image.filters(), for: .normal)
            filtersButton.addTarget(self, action: #selector(onFiltersTap), for: .touchUpInside)

            let badgeView = UIView(frame: CGRect(x: 22, y: 0, width: 8, height: 8))
            badgeView.backgroundColor = MiscStyles.filtersBadgeColor()
            badgeView.layer.cornerRadius = 4

            filtersButton.addSubview(badgeView)
            
            navigationItem.setRightBarButton(UIBarButtonItem(customView: filtersButton), animated: false)
        } else {
            navigationItem.setRightBarButton(UIBarButtonItem(image: R.image.filters(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onFiltersTap)), animated: false)
        }
    }
    
    func reset() {
        drinks.removeAll()
        
        drinksSubject.onNext(drinks)
        
        showHUD()
    }

    func addCategory(name: String, drinks: [Drink]) {
        hud.hide(animated: true)
        
        self.drinks.append(SectionModel(model: name, items: drinks))
        
        drinksSubject.onNext(self.drinks)
    }
    
}
