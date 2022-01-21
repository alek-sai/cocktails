//
//  ButtonStyles.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import UIKit

class ButtonStyles {
    
    // MARK: Buttons
    
    static func blueButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.color.accentColor()
        button.layer.cornerRadius = 12
    }
    
}
