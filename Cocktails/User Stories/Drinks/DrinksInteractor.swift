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
    
    var categoriesToLoad: [Category] = []
    var nextRequest: Request!

}

// MARK: DrinksInteractorProtocol

extension DrinksInteractor: DrinksInteractorProtocol {
    
    func loadCategories() {
        if nextRequest != nil { return }
        nextRequest = Request.loadCategories
        
        drinksNetworkProvider.request(.categories, completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.categoriesToLoad = try JSONDecoder().decode(Categories.self, from: response.data).drinks
                    
                    self.presenter.onSuccessLoadCategories(self.categoriesToLoad)
                    
                    self.nextRequest = nil
                    
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
        guard let nextCategory = categoriesToLoad.first else { return }
        
        if nextRequest != nil { return }
        nextRequest = Request.loadNextDrinksCategory
        
        let name = nextCategory.name
        
        drinksNetworkProvider.request(.drinks(category: name), completion: { result in
            switch result {
            case let .success(response):
                do {
                    self.presenter.onSuccessLoadDrinksCategory(name: name, drinks: try JSONDecoder().decode(Drinks.self, from: response.data).drinks)
                    
                    self.categoriesToLoad.remove(at: 0)
                    
                    self.nextRequest = nil
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
