//
//  VisitorBadge.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class VisitorBadge: UIView {
    var label: UILabel?
    var imageView: UIImageView?

    let size = CGSize(width: 30, height: 30)

    init(withRemainderCount count: Int) {
        super.init(frame: CGRect(origin: .zero, size: size))
        commonConfiguration()
        label = UILabel(frame: bounds)
        label!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label!.textColor = Appearance.Colors.white
        label!.text = count > 0 ? "\(count)+" : "0"
        label!.font = Appearance.Fonts.tiny
        label!.textAlignment = .center
        addSubview(label!)
        label!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        label!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    init(withImageDescriptor imageDescriptor: Surfer.ImageDescriptor?) {
        super.init(frame: CGRect(origin: .zero, size: size))
        commonConfiguration()
        imageView = UIImageView(frame: bounds)
        imageView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView!.contentMode = .scaleAspectFill
        imageView!.image = #imageLiteral(resourceName: "icon_profile-empty")
        addSubview(imageView!)

        switch imageDescriptor {
        case let .hardcoded(name)?: imageView!.image = UIImage(named: name)
        case let .remote(urlString)?: loadImageUrl(url: urlString)
        default: ()
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func loadImageUrl(url urlString: String) {
        ImageLoader.sharedInstance.load(url: urlString) { [weak self] image in
            self?.imageView?.image = image
        }
    }

    private func commonConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        backgroundColor = Appearance.Colors.gray
        clipsToBounds = true
        layer.cornerRadius = size.width / 2
        layer.borderWidth = 2
        layer.borderColor = Appearance.Colors.lightBlue.cgColor
    }
}
