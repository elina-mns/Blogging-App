//
//  SignInHeaderView.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-29.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Explore blogs and articles!"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = width / 3
        imageView.frame = CGRect(x: (width - size)/2, y: 10, width: size, height: size)
        label.frame = CGRect(x: 20, y: imageView.bottom + 10, width: width - 40, height: height - size - 30)
    }

}
