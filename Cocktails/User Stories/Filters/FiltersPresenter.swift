//
//  FiltersPresenter.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation

protocol FiltersPresenterProtocol: AnyObject {
    
}

protocol FiltersPresenterInputsProtocol: AnyObject {
    func viewDidLoad()
    func toggleCategoryFilter(_ row: Int)
    func applyFilters()
    func checkIfFilterChanged(_ categories: [Category]) -> Bool
}

class FiltersPresenter {
    
    // MARK: Linking
    
    var coordinator: FiltersCoordinator!
    var interactor: FiltersInteractor!
    weak var view: FiltersViewController!
    
}

// MARK: FiltersPresenterInputsProtocol

extension FiltersPresenter: FiltersPresenterInputsProtocol {
    
    func viewDidLoad() {
        view.setFilters(interactor.categories)
    }
    
    func toggleCategoryFilter(_ row: Int) {
        interactor.toggleCategoryFilter(row)
        
        view.setFilters(interactor.categories)
    }
    
    func applyFilters() {
        coordinator.drinksCoordinator.setFilteredCategoriesAndApply(interactor.categories)
    }
    
    func checkIfFilterChanged(_ categories: [Category]) -> Bool {
        categories.sorted(by: { $0.name > $1.name }) != coordinator.currentCategories
    }
    
}

// MARK: FiltersPresenterProtocol

extension FiltersPresenter: FiltersPresenterProtocol {}
