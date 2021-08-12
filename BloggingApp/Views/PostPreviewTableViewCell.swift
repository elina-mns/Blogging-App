//
//  PostPreviewTableViewCell.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-08-12.
//

import UIKit

class PostPreviewTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

class PostPreviewTableViewCell: UITableViewCell {

    static let identifier = "PostPreviewTableViewCell"
    
    //Post Image
    private var postImageView: UIImageView = {
        let postImage = UIImageView()
        postImage.layer.masksToBounds = true
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 8
        postImage.contentMode = .scaleAspectFill
        return postImage
    }()
    
    //Post Title
    private var postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(x: separatorInset.left, y: 5, width: contentView.height - 10, height: contentView.height - 10)
        postTitleLabel.frame = CGRect(x: postImageView.right + 5, y: 5, width: contentView.width - 5 - separatorInset.left - postImageView.width, height: contentView.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }
    
    func configure(withViewModel viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        
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
