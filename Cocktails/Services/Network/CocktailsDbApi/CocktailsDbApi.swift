//
//  CocktailsDbApi.swift
//  Cocktails
//
//  Created by Alek Sai on 19/01/2022.
//

import Foundation
import Moya

enum CocktailsDbApi {
    case categories
    case drinks(category: String)
}

// MARK: TargetType

extension CocktailsDbApi: TargetType {
    
    var baseURL: URL {
        switch self {
        case .categories:
            return URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
        case .drinks(let category):
            return URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category.replacingOccurrences(of: " ", with: "_"))")!
        }
    }
    
    var path: String { "" }
    
    var method: Moya.Method { .get }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

}
