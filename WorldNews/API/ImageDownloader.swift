//
//  ImageDownloader.swift
//  WorldNews
//
//  Created by Alex Mosunov on 20.01.2022.
//

import UIKit

struct ImageDownloader {
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(with urlString: String?, completion: @escaping(UIImage?) -> Void) {
        guard let urlString = urlString else {
            completion(nil)
            return
        }
        
        // check for cached image
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        }
        // download image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }

            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    cache.setObject(downloadedImage, forKey: urlString as NSString)
                    completion(downloadedImage)
                }
            })
        }).resume()
    }
    
}
