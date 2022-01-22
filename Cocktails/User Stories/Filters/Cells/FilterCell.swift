//
//  FilterCell.swift
//  Cocktails
//
//  Created by Alek Sai on 20/01/2022.
//

import UIKit
import SnapKit

class FilterCell: UITableViewCell {
    
    // MARK: UI Elements
    
    private let name = UILabel()
    private let checkmark = UIImageView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up
    
    private func setup() {
        selectionStyle = .none
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 17)
        
        contentView.addSubview(name)
        
        checkmark.image = R.image.checkmark()
        
        contentView.addSubview(checkmark)
    }
    
    private func layout() {
        name.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(20)
        }
        
        checkmark.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
        }
    }
    
    // MARK: Public methods
    
    func configureCell(with model: Category) {
        name.text = model.name
        checkmark.isHidden = !model.active
    }
    
}
