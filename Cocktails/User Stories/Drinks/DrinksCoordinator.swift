//
//  DrinksCoordinator.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation
import UIKit

protocol DrinksCoordinatorProtocol {
    func openFilters(navigationContoller: UINavigationController?, categories: [Category])
    func setFilteredCategoriesAndApply(_ categories: [Category])
}

// MARK: DrinksCoordinator

class DrinksCoordinator: BaseCoordinator {
    
    private let drinksView = DrinksViewController()

    override func start() {
        drinksView.title = R.string.localizable.navigatorDrinksTitle()
        
        // MARK: Manual resolving
        
        drinksView.presenter = DrinksPresenter()
        drinksView.presenter.coordinator = self
        drinksView.presenter.interactor = DrinksInteractor()
        drinksView.presenter.interactor.presenter = drinksView.presenter
        drinksView.presenter.view = drinksView
        drinksView.presenter.view.presenter = drinksView.presenter
        
        // MARK: Navigate

        navigationController?.pushViewController(drinksView, animated: true)
    }
    
}

// MARK: DrinksCoordinatorProtocol

extension DrinksCoordinator: DrinksCoordinatorProtocol {
    
    func openFilters(navigationContoller: UINavigationController?, categories: [Category]) {
        let filtersCoordinator = FiltersCoordinator(navigationController: navigationController)
        
        filtersCoordinator.categories = categories
        filtersCoordinator.drinksCoordinator = self

        filtersCoordinator.start()
    }
    
    func setFilteredCategoriesAndApply(_ categories: [Category]) {
        navigationController?.popViewController(animated: true)
        
        drinksView.presenter.categories = categories
        drinksView.presenter.refreshFilter()
    }

}
