//
//  MovieDetailViewController.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var movie: Movie
    private var movieDetail = [MovieDetails]()
    private var isPoster: Bool
    private var resource: [[String: Any]] = []
    private let viewModel = FirstViewModel()
    
    //MARK: - UIKit elements SetUp
    
    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FirstSectionSecondScreenCollectionViewCell.self, forCellWithReuseIdentifier: FirstSectionSecondScreenCollectionViewCell.identifier)
        collectionView.register(SecondSectionSecondScreenCollectionViewCell.self, forCellWithReuseIdentifier: SecondSectionSecondScreenCollectionViewCell.identifier)
        collectionView.register(SecondSectionSecondScreenHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SecondSectionSecondScreenHeaderCollectionReusableView.identifier)
        return collectionView
    }()
    
    private var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.color = .white
        return loader
    }()
    
    init(movie: Movie, isPoster: Bool) {
        self.movie = movie
        self.isPoster = isPoster
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        setUpMovieDetailCollectionView()
        setUpLoaderView()
        setNavigationBar()
        fetchMovieDetailData()
        setUpBinders()
        
    }
    
    private func setUpMovieDetailCollectionView() {
        view.addSubview(movieDetailCollectionView)
        
        movieDetailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setUpLoaderView() {
        view.addSubview(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetchMovieDetailData() {
        loaderView.startAnimating()
        viewModel.fetchMovieById(movieId: movie.imdb)
    }
    
    //MARK: - MVVM Binders SetUp
    
    private func setUpBinders() {
        viewModel.observableValue.bind { collection in
            self.resource = collection
            
            DispatchQueue.main.async {
                self.loaderView.stopAnimating()
                self.movieDetailCollectionView.reloadData()
            }
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) in
            switch sectionIndex {
            case 0:
                return self.firstSectionIndex()
            default:
                return self.secondSectionIndex()
            }
            
        }
    }
    
    //MARK: - CollectionView Section SetUp
    
    private func firstSectionIndex() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = isPoster ? NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(400)) : NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    private func secondSectionIndex() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func setGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.0934105888, green: 0.07379171997, blue: 0.3734465991, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = .init(x: 0.0, y: 0.0)
        gradient.endPoint = .init(x: 1.0, y: 1.0)
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(goBackButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
    }
    
    @objc func goBackButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let first = view.layer.sublayers?.first as? CAGradientLayer {
            first.frame = view.bounds
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resource.isEmpty ? 0 : resource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let itemId = FirstSectionSecondScreenCollectionViewCell.identifier
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath) as! FirstSectionSecondScreenCollectionViewCell
            
            item.configureImage(image: movie.fanart)
            
            return item
        } else {
            let itemId = SecondSectionSecondScreenCollectionViewCell.identifier
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath) as! SecondSectionSecondScreenCollectionViewCell
            
            guard let value = resource[indexPath.section].values.first else { return UICollectionViewCell()}
            
            let firstValue: String
            if let string = value as? String {
                firstValue = string
            } else if let array = value as? [String], let firstInArray = array.first {
                firstValue = firstInArray
            } else {
                firstValue = "Text"
            }
            
            item.configureLabel(text: firstValue)
            
            return item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerId = SecondSectionSecondScreenHeaderCollectionReusableView.identifier
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SecondSectionSecondScreenHeaderCollectionReusableView
            
            guard let first = resource[indexPath.section].keys.first else { return UICollectionViewCell()}
            headerView.configure(text: first.capitalized)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
