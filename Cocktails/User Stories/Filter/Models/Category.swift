//
//  Category.swift
//  Cocktails
//
//  Created by Alek Sai on 20/01/2022.
//

import Foundation

// MARK: Categories

struct Categories: Codable {
    let drinks: [Category]
}

// MARK: Category

struct Category: Codable {
    let name: String
    var active: Bool = true
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}

// MARK: Category Equation
    
extension Category: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.active == rhs.active
    }

}
