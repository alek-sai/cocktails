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

struct Category: Codable, Equatable {
    let name: String
    var active: Bool = true
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}
