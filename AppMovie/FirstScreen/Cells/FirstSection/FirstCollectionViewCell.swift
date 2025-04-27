//
//  FirstCollectionViewCell.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 26.04.2025.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FirstCollectionViewCell"
    
    private var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3019607843, blue: 0.4901960784, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    private var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, there mate"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    func configureCell(movie: Movie) {
        textLabel.text = movie.title
        movieImageView.image = movie.fanart
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpMainView()
        setUpMovieImageView()
        setUpTextLabel()
        
    }
    
    private func setUpMainView() {
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpTextLabel() {
        mainView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setUpMovieImageView() {
        mainView.addSubview(movieImageView)
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
