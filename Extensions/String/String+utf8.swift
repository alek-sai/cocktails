//
//  String+utf8.swift
//  Cocktails
//
//  Created by Alek Sai on 19/01/2022.
//

import Foundation

extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
