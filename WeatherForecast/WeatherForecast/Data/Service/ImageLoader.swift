//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/14.
//

import UIKit.UIImage

class ImageCacher: NSCache<NSNumber, UIImage> {
    static let shared = ImageCacher()
    
    private override init() {
        super.init()
        self.countLimit = 100
    }
    
    func save(_ image: UIImage, forkey: Int) {
        setObject(image, forKey: NSNumber(value: forkey))
    }
    
    func pullImage(forkey: Int) -> UIImage? {
        guard let image = object(forKey: NSNumber(value: forkey)) else {
            return nil
        }
        return image
    }
}

class ImageLoader {
    
}

extension ImageLoader {
    static func downloadImage(reqeustURL: String?, imageCachingKey: Int, _ completionHandler: @escaping (UIImage) -> ()) {
        
        if let image = ImageCacher.shared.pullImage(forkey: imageCachingKey) {
            completionHandler(image)
            return
        }
        
        guard let urlString = reqeustURL,
              let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            
            guard let downloadImage = UIImage(data: data) else { return }
            
            ImageCacher.shared.save(downloadImage, forkey: imageCachingKey)
            completionHandler(downloadImage)
        }
        
        task.resume()
    }
}
