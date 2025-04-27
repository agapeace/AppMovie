//
//  SecondSectionSecondScreenCollectionViewCell.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class SecondSectionSecondScreenCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SecondSectionSecondScreenCollectionViewCell"
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Text"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    func configureLabel(text: String) {
        textLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpTextLabel()
    }
    
    private func setUpTextLabel() {
        contentView.addSubview(textLabel)
        contentView.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3019607843, blue: 0.4901960784, alpha: 1)
        contentView.layer.cornerRadius = 15
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
