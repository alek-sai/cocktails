//
//  FiltersInteractor.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import Foundation
import Moya

protocol FiltersInteractorProtocol {
    func toggleCategoryFilter(_ row: Int)
}

class FiltersInteractor {
    
    // MARK: Linking
    
    weak var presenter: FiltersPresenterProtocol!
    
    // MARK: Data
    
    var categories: [Category] = []

}

// MARK: FiltersInteractorProtocol

extension FiltersInteractor {
    
    func toggleCategoryFilter(_ row: Int) {
        categories[row].active.toggle()
        
        if !categories.map({ $0.active }).contains(true) {
            categories[row].active.toggle()
        }
    }
    
}
