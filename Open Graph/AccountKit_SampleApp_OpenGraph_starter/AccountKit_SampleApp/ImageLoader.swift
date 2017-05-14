//
//  ImageLoader.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal final class ImageLoader {
    static let sharedInstance = ImageLoader()

    private var loadImagesGroup = DispatchGroup()

    /// Load images for an array of surfers and call completion when complete
    func loadImages(for surfers: [Surfer], completion: @escaping () -> Void) {
        let surfers = surfers.filter { $0.readyToLoadImage }
        guard !surfers.isEmpty else {
            return
        }

        for surfer in surfers {
            loadImagesGroup.enter()
            surfer.loadImage { _ in
                self.loadImagesGroup.leave()
            }
        }

        loadImagesGroup.notify(queue: .main) {
            completion()
        }
    }

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

// -----------------------------------------------------------------------------
// MARK: - UIImageView extension for image loading

internal extension UIImageView {
    /// Either uses a surfer's loaded image, or attempts to load an image based
    /// on the surfer's imageUrl
    func loadImage(for surfer: Surfer) {
        if let surferImage = surfer.image {
            image = surferImage
        } else if let url = surfer.imageUrl {
            ImageLoader.sharedInstance.load(url: url) { [weak self] image in
                self?.image = image
            }
        }
    }

    /// Configures the image view with the profile's existing image, or attempts
    /// to load and configure the image from an URL
    func loadImage(for profile: Profile) {
        profile.loadProfileImage { [weak self] image in
            self?.image = image
        }
    }
}
