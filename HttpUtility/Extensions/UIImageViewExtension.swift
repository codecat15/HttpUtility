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
    func downloadImageFromUrl(urlString: String)
    {
        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if(data != nil)
            {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }.resume()

    }
}
