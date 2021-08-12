//
//  PostHeaderTableViewCell.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-08-12.
//

import UIKit

class PostHeaderTableViewCellViewModel {
    let imageURL: URL?
    var imageData: Data?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "PostHeaderTableViewCell"

    //Post Image
    private var postImageView: UIImageView = {
        let postImage = UIImageView()
        postImage.layer.masksToBounds = true
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        return postImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(withViewModel viewModel: PostHeaderTableViewCellViewModel) {
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            //Fetch the image & cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
