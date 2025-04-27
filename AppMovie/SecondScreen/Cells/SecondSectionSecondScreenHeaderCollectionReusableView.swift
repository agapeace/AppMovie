//
//  SecondSectionSecondScreenHeaderCollectionReusableView.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class SecondSectionSecondScreenHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "SecondSectionSecondScreenHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpTitleLabel()
    }
    
    func setUpTitleLabel() {
        addSubview(titleLabel)
        titleLabel.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
