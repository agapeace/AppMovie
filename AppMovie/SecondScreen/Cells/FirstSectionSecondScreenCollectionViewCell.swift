//
//  FirstSectionSecondScreenCollectionViewCell.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class FirstSectionSecondScreenCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FirstSectionSecondScreenCollectionViewCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func configureImage(image: UIImage) {
        mainImageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainView()
        setUpMainImageView()
    }
    
    private func setUpMainView() {
        contentView.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpMainImageView() {
        mainView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
