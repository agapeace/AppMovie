//
//  CacheManager.swift
//  AppMovie
//
//  Created by Damir Agadilov  on 27.04.2025.
//

import Foundation
import UIKit

final class CacheManager {
    
    static let shared = CacheManager()
    private init() {}
    private let lock = NSLock()
    private var count = 0
    
    
    private let cache = NSCache<NSString, UIImage>()
    
    func setCacheObject(object: UIImage, forKey: String) {
        lock.lock()
        cache.setObject(object, forKey: forKey as NSString)
        count += 1
        lock.unlock()
    }
    
    func getCacheObject(forKey: String) -> UIImage? {
        lock.lock()
        let image = cache.object(forKey: forKey as NSString)
        lock.unlock()
        return image
    }
    
    func getCacheCount() -> Int{
        return count
    }
    
}
