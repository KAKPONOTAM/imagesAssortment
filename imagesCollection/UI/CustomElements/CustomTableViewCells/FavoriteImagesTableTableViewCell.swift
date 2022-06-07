import UIKit
import Kingfisher

class FavoriteImagesTableTableViewCell: UITableViewCell {
    private let favoritePhotoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let roundedView = imageView.roundingView()
        imageView = roundedView
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubview() {
        contentView.addSubview(favoritePhotoImageView)
        contentView.addSubview(authorNameLabel)
    }
    
    private func setupConstraints() {
        let sidesOffset: CGFloat = 5
        NSLayoutConstraint.activate([
            favoritePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: sidesOffset),
            favoritePhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidesOffset),
            favoritePhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -sidesOffset),
            favoritePhotoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: favoritePhotoImageView.trailingAnchor, constant: sidesOffset),
            authorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: sidesOffset),
            authorNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: sidesOffset),
            authorNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: sidesOffset)
        ])
    }
    
    func configure(with result: Results, with image: UIImage) {
        favoritePhotoImageView.image = image
        authorNameLabel.text = result.user.name
    }
}
