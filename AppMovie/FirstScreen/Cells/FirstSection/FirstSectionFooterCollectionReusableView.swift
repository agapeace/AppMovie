//
//  FirstSectionFooterCollectionReusableView.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 26.04.2025.
//

import UIKit

class FirstSectionFooterCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "FirstSectionFooterCollectionReusableView"
    
    private var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.pageIndicatorTintColor = .white
        page.currentPageIndicatorTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return page
        
    }()
    
    func configure(numberOfPages: Int, currentPage: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpPageControl()
    }
    
    func setUpPageControl() {
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
