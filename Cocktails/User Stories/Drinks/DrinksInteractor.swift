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
    func retry()
}

enum Request {
    case loadCategories
    case loadNextDrinksCategory
}

class DrinksInteractor {
    
    // MARK: Linking
    
    weak var presenter: DrinksPresenterProtocol!
    
    // MARK: Data Providers
    
    var drinksNetworkProvider = MoyaProvider<CocktailsDbApi>()
    
    // MARK: Data
    
    var categories: [Category] = []
    var nextRequest: Request!

}

// MARK: DrinksInteractorProtocol

extension DrinksInteractor: DrinksInteractorProtocol {
    
    func loadCategories() {
        nextRequest = Request.loadCategories
        
        drinksNetworkProvider.request(.categories, completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.categories = try JSONDecoder().decode(Categories.self, from: response.data).drinks
                    
                    self.presenter.onSuccessLoadCategories(self.categories)
                    
                    self.loadNextDrinksCategory()
                } catch _ {
                    self.presenter.onError()
                }
            case .failure(_):
                self.presenter.onError()
            }
        })
    }
    
    func loadNextDrinksCategory() {
        guard let nextCategory = categories.first else { return }
        
        nextRequest = Request.loadNextDrinksCategory
        
        let name = nextCategory.name
        
        drinksNetworkProvider.request(.drinks(category: name), completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.categories.remove(at: 0)
                    
                    self.presenter.onSuccessLoadDrinksCategory(name: name, drinks: try JSONDecoder().decode(Drinks.self, from: response.data).drinks)
                } catch _ {
                    self.presenter.onError()
                }
            case .failure(_):
                self.presenter.onError()
            }
        })
    }
    
    func retry() {
        switch nextRequest {
        case .loadCategories:
            loadCategories()
        case .loadNextDrinksCategory:
            loadNextDrinksCategory()
        default: break
        }
    }
    
}
