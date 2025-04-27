//
//  FirstSectionCollectionReusableView.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 26.04.2025.
//

import UIKit

class FirstSectionCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "FirstSectionCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Text"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    func configure(text: String) {
        titleLabel.text = text
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.frame = bounds
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
