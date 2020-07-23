//
//  UIImageViewExtension.swift
//  HttpUtility
//
//  Created by CodeCat15 on 7/21/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func downloadImageFromUrl(imageUrl: URL, placeHolderImage: String)
    {
        self.image = UIImage(named: placeHolderImage)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
