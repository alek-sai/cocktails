//
//  FiltersCoordinator.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation

class FiltersCoordinator: BaseCoordinator {
    
    // MARK: Another Modules
    
    var drinksCoordinator: DrinksCoordinator!
    
    // MARK: Linking
    
    let filtersView = FiltersViewController()
    
    // MARK: Data
    
    var currentCategories: [Category] = []
    
    // MARK: Convienient start with external data binding
    
    func startWithCategories(_ categories: [Category]) {
        start()
        
        currentCategories = categories.sorted(by: { $0.name > $1.name })
        filtersView.presenter.interactor.categories = categories
    }

    override func start() {
        filtersView.title = R.string.localizable.navigatorFiltersTitle()
        
        // MARK: Manual resolving
        
        filtersView.presenter = FiltersPresenter()
        filtersView.presenter.coordinator = self
        filtersView.presenter.interactor = FiltersInteractor()
        filtersView.presenter.interactor.presenter = filtersView.presenter
        filtersView.presenter.view = filtersView
        filtersView.presenter.view.presenter = filtersView.presenter
        
        // MARK: Navigate

        navigationController?.pushViewController(filtersView, animated: true)
    }

}
