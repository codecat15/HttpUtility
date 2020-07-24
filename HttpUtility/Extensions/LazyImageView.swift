//
//  LazyImageView.swift
//  HttpUtility
//
//  Created by CodeCat15 on 7/24/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation
import UIKit

class LazyImageView: UIImageView
{
    private let imageCache = NSCache<AnyObject, UIImage>()

    func loadImage(fromURL imageUrl: URL, placeHolderName: String)
    {
        self.image = UIImage(named: placeHolderName)

        // loading the images from cache
        if let cachedImage = imageCache.object(forKey: imageUrl as AnyObject){
            self.image = cachedImage
            return
        }

        // if image is not present in the cache then get it from the server
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageUrl as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
