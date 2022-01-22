//
//  DrinksPresenter.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation

protocol DrinksPresenterProtocol: AnyObject {
    func onSuccessLoadCategories(_ categories: [Category])
    func onSuccessLoadDrinksCategory(name: String, drinks: [Drink])
    func onError()
}

protocol DrinksPresenterInputsProtocol: AnyObject {
    func viewDidLoad()
    func loadNextDrinkCategory()
    func retry()
    func openFilters()
    func refreshFilter()
}

class DrinksPresenter {
    
    // MARK: Linking
    
    var coordinator: DrinksCoordinator!
    var interactor: DrinksInteractor!
    weak var view: DrinksViewController!
    
    // MARK: Data
    
    var categories: [Category] = []
    
}

// MARK: DrinksPresenterInputsProtocol

extension DrinksPresenter: DrinksPresenterInputsProtocol {
    
    func viewDidLoad() {
        interactor.loadCategories()
    }
    
    func loadNextDrinkCategory() {
        interactor.loadNextDrinksCategory()
    }
    
    func retry() {
        interactor.retry()
    }
    
    func openFilters() {
        coordinator.openFilters(navigationContoller: view.navigationController, categories: categories)
    }
    
    func refreshFilter() {
        view?.reset()
        view?.setFilterBadgeEnabled(categories.filter { !$0.active }.count > 0)
        
        interactor.categories = categories.filter { $0.active }
        interactor.loadNextDrinksCategory()
    }
    
}

// MARK: DrinksPresenterProtocol

extension DrinksPresenter: DrinksPresenterProtocol {
    
    func onSuccessLoadCategories(_ categories: [Category]) {
        self.categories = categories
    }
    
    func onSuccessLoadDrinksCategory(name: String, drinks: [Drink]) {
        view?.addCategory(name: name, drinks: drinks)
    }
    
    func onError() {
        view?.showError()
    }
    
}
