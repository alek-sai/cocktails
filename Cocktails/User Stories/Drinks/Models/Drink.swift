//
//  Drink.swift
//  Cocktails
//
//  Created by Alek Sai on 19/01/2022.
//

import Foundation

// MARK: Drinks

struct Drinks: Codable {
    let drinks: [Drink]
}

// MARK: Drink

struct Drink: Codable {
    let id: String
    let name: String
    let imageUrl: String
}

extension Drink {
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case imageUrl = "strDrinkThumb"
    }
}
