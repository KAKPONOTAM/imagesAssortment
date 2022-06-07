import UIKit

class LoadViewController: UIViewController {
    private let randomImageType = "random"
    private let networkManager = NetworkManager<ImagesData>()
    
    private let loadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.loadImage.titleImage
        imageView.alpha = 0
        return imageView
    }()
    
    private let loadSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true
        spinner.color = .orange
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        animateLoadImageViewAndPresentSearchViewController()
    }
    
    private func addSubview() {
        view.addSubview(loadImageView)
        loadImageView.addSubview(loadSpinner)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadImageView.topAnchor.constraint(equalTo: view.topAnchor),
            loadImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadSpinner.centerXAnchor.constraint(equalTo: loadImageView.centerXAnchor),
            loadSpinner.centerYAnchor.constraint(equalTo: loadImageView.centerYAnchor)
        ])
    }
    
    private func animateLoadImageViewAndPresentSearchViewController() {
        UIView.animate(withDuration: 1.5) {
            self.loadImageView.alpha = 1
        } completion: { _ in
            self.loadSpinner.isHidden = false
            self.getImages()
        }
    }
    
    private func getImages() {
        loadSpinner.startAnimating()
        networkManager.getRandomImages(url: .searchURL(imageType: randomImageType)) { [weak self] imagesData in
            let imagesViewController = MainTabBarViewController(images: imagesData)
            imagesViewController.modalPresentationStyle = .overFullScreen
            self?.present(imagesViewController, animated: true)
            self?.loadSpinner.isHidden = true
            self?.loadImageView.image = nil
        }
    }
}
