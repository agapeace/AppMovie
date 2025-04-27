//
//  ObservableObjectSecondScreen.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import Foundation


final class ObservableObjectSecondScreen<T> {
    
    var valueArr: [[String: Any]] {
        didSet {
            listener?(valueArr)
        }
    }
        
    private var listener: (([[String: Any]]) -> Void)?
        
        
    init(valueArr: [[String: Any]]) {
        self.valueArr = valueArr
    }
        
        
    func bind(listener: @escaping ([[String: Any]]) -> Void) {
        self.listener = listener
    }
}
