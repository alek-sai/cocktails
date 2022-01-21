//
//  FiltersCoordinator.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation

// MARK: FiltersCoordinator

class FiltersCoordinator: BaseCoordinator {
    
    var categories: [Category]!
    var drinksCoordinator: DrinksCoordinator!

    override func start() {
        let filtersView = FiltersViewController()
        
        filtersView.title = R.string.localizable.navigatorFiltersTitle()
        
        // MARK: Manual resolving
        
        filtersView.presenter = FiltersPresenter()
        filtersView.presenter.coordinator = self
        filtersView.presenter.interactor = FiltersInteractor()
        filtersView.presenter.interactor.presenter = filtersView.presenter
        filtersView.presenter.view = filtersView
        filtersView.presenter.view.presenter = filtersView.presenter
        
        // MARK: External data binding
        
        filtersView.presenter.interactor.categories = categories
        
        // MARK: Navigate

        navigationController?.pushViewController(filtersView, animated: true)
    }

}
