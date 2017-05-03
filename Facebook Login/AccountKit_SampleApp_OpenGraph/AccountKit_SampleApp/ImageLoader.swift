//
//  ImageLoader.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal struct ImageLoader {
    static let sharedInstance = ImageLoader()

    /// A helper method for loading images from an URL. In this sample code, 
    /// every image is fetched separately via this helper struct. In a real
    /// app we'd want to organize this a bit better.
    func load(url urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Couldn't form URL for supplied string")
            // handle
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("An error occurred fetching an image from \(url): \(error.localizedDescription)")
                completion(nil)
            }
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Couldn't create image from data")
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
}
