//
//  SecondSectionCollectionViewCell.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class SecondSectionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SecondSectionCollectionViewCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3019607843, blue: 0.4901960784, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Default text"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func configure(movie: Movie) {
        secondImageView.image = movie.fanart
        titleLabel.text = movie.title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainView()
        setUpImageView()
    }
    
    private func setUpMainView() {
        contentView.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpImageView() {
        mainView.addSubview(secondImageView)
        
        secondImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(10)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
