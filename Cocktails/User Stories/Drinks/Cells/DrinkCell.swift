//
//  DrinkCell.swift
//  Cocktails
//
//  Created by Alek Sai on 19/01/2022.
//

import UIKit
import SnapKit
import SDWebImage

class DrinkCell: UITableViewCell {
    
    // MARK: UI Elements
    
    private let name = UILabel()
    private let image = UIImageView()
        
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
        
        contentView.addSubview(image)
        contentView.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func layout() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.equalTo(52)
            make.height.equalTo(52)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.image.snp.trailing).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(20)
        }
    }
    
    // MARK: Public methods
    
    func configureCell(with model: Drink) {
        name.text = model.name
        
        image.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: R.image.placeholder())
    }
    
}
