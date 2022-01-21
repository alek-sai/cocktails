//
//  DrinksInteractor.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation
import Moya

protocol DrinksInteractorProtocol {
    func loadCategories()
    func loadNextDrinksCategory()
}

class DrinksInteractor {
    
    // MARK: Linking
    
    weak var presenter: DrinksPresenterProtocol!
    
    // MARK: Data Providers
    
    var drinksNetworkProvider = MoyaProvider<CocktailsDbApi>()
    
    // MARK: Data
    
    var categories: [Category] = []

}

// MARK: DrinksInteractorProtocol

extension DrinksInteractor: DrinksInteractorProtocol {
    
    func loadCategories() {
        drinksNetworkProvider.request(.categories, completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.categories = try JSONDecoder().decode(Categories.self, from: response.data).drinks
                    
                    self.presenter.onSuccessLoadCategories(self.categories)
                    
                    self.loadNextDrinksCategory()
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func loadNextDrinksCategory() {
        guard let nextCategory = categories.first else { return }
        
        let name = nextCategory.name
        
        categories.remove(at: 0)
        
        drinksNetworkProvider.request(.drinks(category: name), completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.presenter.onSuccessLoadDrinksCategory(name: name, drinks: try JSONDecoder().decode(Drinks.self, from: response.data).drinks)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
}
