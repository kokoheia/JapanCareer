//
//  Extensions.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/04/01.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageWithCache(with urlString: String) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, responce, err) in
                if err != nil {
                    print(err!)
                    return
                }
                let profileImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.image = profileImage
                }

                imageCache.setObject(profileImage!, forKey: urlString as NSString)
                
            }).resume()
        }
    }
    
}

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static var mainColor = UIColor(r: 240, g: 99, b: 115)
    static var darkBlueColor = UIColor(r: 49, g: 92, b: 130)
    static var myGrayColor = UIColor(r: 150, g: 150, b: 150, a: 0.5)
    static var myLightGrayColor = UIColor(r: 218, g: 214, b: 210)
    static var chatGrayColor = UIColor(r:240, g: 240, b: 240)
    static var listBackgroundColor = UIColor(r: 216, g: 216, b: 216)
    static var textInputBackgroundGray = UIColor(r: 238, g: 238, b: 238, a: 0.63)
    static var filteringMenuClear = UIColor(r: 240, g: 236, b: 236, a: 0.43)
    static var applyButtonGreen = UIColor(r: 122, g: 187, b: 131)
    static var applyButtonHighlightedGreen = UIColor(r: 122, g: 187, b: 131, a: 0.8)
    static var lightPinkColor = UIColor(r: 252, g: 184, b: 192)
    static var editCollectionViewHeaderLightPink =  UIColor(r: 240, g: 99, b: 115, a: 0.76)
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
