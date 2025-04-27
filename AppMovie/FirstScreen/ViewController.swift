//
//  ViewController.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 26.04.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var resource = [Movie]()
    private var secondSectionResource = [Movie]()
    private var thirdSectionResource = [Movie]()
    private let viewModel = FirstViewModel()
    
    //MARK: - UIKit Elements SetUp
    private lazy var movieCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: FirstCollectionViewCell.identifier)
        collection.register(SecondSectionCollectionViewCell.self, forCellWithReuseIdentifier: SecondSectionCollectionViewCell.identifier)
        collection.register(FirstSectionCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: FirstSectionCollectionReusableView.identifier)
        collection.register(FirstSectionFooterCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: FirstSectionFooterCollectionReusableView.identifier)
        collection.register(SecondSectionFooterCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: SecondSectionFooterCollectionReusableView.identifier)
        
        return collection
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.color = .white
        return loader
    }()
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {(mainIndex, env) in
            switch mainIndex {
            case 0:
                return self.firstSectionIndex()
            default:
                return self.secondSectionIndex()
            }

        }
    }
    
    //MARK: - CollectionView Index SetUp
    
    private func firstSectionIndex() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, scrollOffset, environment) in
            let currentIndex = Int(scrollOffset.x / (self?.movieCollectionView.frame.size.width ?? 400))
            self?.updatePageControl(index: currentIndex)
        }
        
        return section
    }
    
    private func secondSectionIndex() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .absolute(220)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom)
        
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return section
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        setUpCollectionView()
        setUpNavigationBar()
        setUpLoaderView()
        fetchMovieData()
        setUpBinders()
        
    }

    private func setUpCollectionView() {
        view.addSubview(movieCollectionView)
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setUpLoaderView() {
        view.addSubview(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetchMovieData() {
        loaderView.startAnimating()        
        viewModel.fetAllMovies()
    }
    
    //MARK: - MVVM Binders SetUp
    
    private func setUpBinders() {
        viewModel.firstSectionObservable.bind { collection in
            self.resource = collection
        }
        
        viewModel.secondSectionObservable.bind { collection in
            self.secondSectionResource = collection
        }
        
        viewModel.thirdSectionObservable.bind { collection in
            self.thirdSectionResource = collection
            
            DispatchQueue.main.async {
                self.loaderView.stopAnimating()
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    private func updatePageControl(index: Int) {
        if let footer = movieCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: 0)) as? FirstSectionFooterCollectionReusableView {
            footer.configure(numberOfPages: resource.count, currentPage: index)
        }
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
    
    private func setUpNavigationBar() {
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let first = view.layer.sublayers?.first as? CAGradientLayer {
            first.frame = view.bounds
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return resource.count
        case 1:
            return secondSectionResource.count
        default:
            return thirdSectionResource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let itemId = FirstCollectionViewCell.identifier
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath) as! FirstCollectionViewCell
            item.configureCell(movie: resource[indexPath.row])
            return item
        } else {
            let itemId = SecondSectionCollectionViewCell.identifier
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath) as! SecondSectionCollectionViewCell
            switch indexPath.section {
            case 1:
                item.configure(movie: secondSectionResource[indexPath.row])
            default:
                item.configure(movie: thirdSectionResource[indexPath.row])
            }
            
            return item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerId = FirstSectionCollectionReusableView.identifier
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! FirstSectionCollectionReusableView
            
            switch indexPath.section {
            case 0:
                let text = resource.count == 0 ? "" : "Trending Movies"
                headerView.configure(text: text)
            case 1:
                let text = secondSectionResource.count == 0 ? "" : "Box Office Movies"
                headerView.configure(text: text)
            default:
                let text = thirdSectionResource.count == 0 ? "" : "Upcoming Movies"
                headerView.configure(text: text)
            }
            
            return headerView
        }
        
       
        if kind == UICollectionView.elementKindSectionFooter {
            if indexPath.section == 0 {
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FirstSectionFooterCollectionReusableView.identifier,
                    for: indexPath) as! FirstSectionFooterCollectionReusableView

                footer.configure(numberOfPages: resource.count, currentPage: 0)
                return footer
            } else {
                let emptyFooter = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SecondSectionFooterCollectionReusableView.identifier,
                    for: indexPath) as! SecondSectionFooterCollectionReusableView

                return emptyFooter
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            viewModel.pushDetailsViewController(navigation: self, currentMovie: resource[indexPath.row], isPoster: false)
        case 1:
            viewModel.pushDetailsViewController(navigation: self, currentMovie: secondSectionResource[indexPath.row], isPoster: true)
        default:
            viewModel.pushDetailsViewController(navigation: self, currentMovie: thirdSectionResource[indexPath.row], isPoster: true)
        }
    }
}

