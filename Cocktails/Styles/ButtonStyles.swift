//
//  ButtonStyles.swift
//  Cocktails
//
//  Created by Alek Sai on 18/01/2022.
//

import UIKit

class ButtonStyles {
    
    // MARK: Colors
    
    static func blueButtonEnabledColor() -> UIColor {
        UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    }
    
    static func blueButtonDisabledColor() -> UIColor {
        UIColor(red: 0.909, green: 0.909, blue: 0.909, alpha: 1)
    }
    
    // MARK: Buttons
    
    static func blueButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = blueButtonEnabledColor()
        button.layer.cornerRadius = 12
    }
    
}
